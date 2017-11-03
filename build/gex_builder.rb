require 'aws-sdk'
require 'vault'

class GexBuilder

  gex_registry_cred = Vault.logical.read("secret/gex_registry_cred").data
  gex_dockerhub_cred = Vault.logical.read("secret/gex_dockerhub_cred").data

  REGISTRIES = {
      gex: {
          url: gex_registry_cred[:url],
          username: gex_registry_cred[:username],
          password: gex_registry_cred[:password]
      },
      dockerhub: {
          url: 'docker.io',
          username: gex_dockerhub_cred[:username],
          password: gex_dockerhub_cred[:password]
      }
  }.freeze

  # config  - Hash
  def initialize(config)
    @config = config
    @pconfig = Packer::Config.new(File.join(@config.fetch(:project_name), "#{@config.fetch(:container_name)}-build.json"))

    build_docker_base
    chef_solo_provisioner
    send("#{@config.fetch(:postprocessor)}_post_processor", @config.fetch(:registry))

    @pconfig.validate
    @pconfig.build
  end

  def build_docker_base
    builder = @pconfig.add_builder(Packer::Builder::DOCKER)
    builder.image(@config.fetch(:base_image))
    builder.pull(false)
    builder.commit(true)

    # todo
    #changes = @config[:changes] || []
    #if @config[:first_run]
    #default_cmd = @config[:first_run].fetch('default_cmd')
    #changes << "ENTRYPOINT [\"bootstrap.sh\"]"
    #end

    builder.changes(@config[:changes]) if @config[:changes]

    # fx - if no curl in container
    shell_provisioner = @pconfig.add_provisioner(Packer::Provisioner::SHELL)
    shell_provisioner.inline(["apt-get update && apt-get -y install curl"])
  end

  def chef_solo_provisioner
    provisioner = @pconfig.add_provisioner(Packer::Provisioner::CHEF_SOLO)
    default_cookbooks_path = [File.join(File.dirname(__FILE__), @config.fetch(:project_name), 'containers', @config.fetch(:container_name), 'cookbooks')]

    cookbook_paths = @config[:cookbooks_path] ? @config[:cookbooks_path] : default_cookbooks_path

    cookbooks_base_dir = File.join(File.dirname(__FILE__), @config.fetch(:project_name), 'cookbooks', '*')
    Dir[cookbooks_base_dir].each do |cookbook_path|
      cookbook_paths.push(cookbook_path)
      puts "Cookbooks dir #{cookbook_path} added"
    end

    provisioner.cookbook_paths(cookbook_paths)

    run_list = @config[:run_list] || ["recipe[default::default]"]
    provisioner.run_list(run_list)

    json = @config[:json_custom] || {}

    json['env'] = @config.fetch(:env)

    secrets = Vault.logical.read("secret/builder").data
    container_secrets = secrets[@config.fetch(:tag).to_sym][@config.fetch(:container_name).to_sym] rescue {}

    provisioner.json({attributes: json, secrets: container_secrets})

    provisioner.prevent_sudo(true)
  end


  def registry_post_processor(registry_name)
    tag_postprocessor = @pconfig.add_postprocessor(Packer::PostProcessor::DOCKER_TAG)

    tag_postprocessor.repository("#{GexBuilder::REGISTRIES[registry_name][:url]}/#{@config.fetch(:container_name)}")
    #tag_postprocessor.repository("#{@config.fetch(:project_name)}/#{@config.fetch(:container_name)}")
    tag_postprocessor.tag(@config.fetch(:tag))

    push_postprocessor = @pconfig.add_postprocessor(Packer::PostProcessor::DOCKER_PUSH)
    push_postprocessor.login(true)

    # push_postprocessor.login_username(GexBuilder::GEX_REGISTRY[:username])
    # push_postprocessor.login_password(GexBuilder::GEX_REGISTRY[:password])
    # push_postprocessor.login_server(GexBuilder::GEX_REGISTRY[:url])

    push_postprocessor.login_username(GexBuilder::REGISTRIES[registry_name][:username])
    push_postprocessor.login_password(GexBuilder::REGISTRIES[registry_name][:password])
    push_postprocessor.login_server(GexBuilder::REGISTRIES[registry_name][:url]) #if GexBuilder::REGISTRIES[registry_name][:url]
  end

  def tar_post_processor
    path = File.join('/tmp', "#{@config.fetch(:container_name)}.tar")
    save_postprocessor = @pconfig.add_postprocessor(Packer::PostProcessor::DOCKER_SAVE)
    save_postprocessor.path(path)

    path
  end

  def s3_post_processor
    path = tar_post_processor
    s3 = Aws::S3::Resource.new(
        region: 'us-west-1',
        access_key_id: 'PH_GEX_KEY_ID',
        secret_access_key: 'PH_GEX_ACESS_KEY'
    )
    obj = s3.bucket('gex-containers').object("#{@config.fetch(:container_name)}.tar")
    obj.upload_file(path)
  end


end