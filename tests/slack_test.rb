require 'slack-ruby-client'
require 'json'


COLORS = {
    start: '#00C853',
    stop: '#FFA726',
    kill: '#FF7043',
    die: '#c30000',
    attach: '#A5D6A7',

}

EVENTS ={
  start: {send_to_slack: true, color: :green},
  stop: {send_to_slack: true, color: :green},
}


def compose_action_tmpl(event)
  info = compose_action_srt(event)
  return_att("Compose event: #{event['service']} - #{event['action']}", "#{event['service']} - #{event['action']}", info, COLORS[event['action'].to_sym])
end


def compose_action_srt(event)
  <<-EOF
    Time: #{event['time']}
    Type: #{event['type']}
    Attributes: #{event['attributes']}
  EOF
end

def return_att(pre_text, title, text, color)
  {
      :type => :att,
      :att =>
          [{
               pretext: pre_text,
               title: title,
               text: text,
               color: color
           }]
  }
end



Slack.configure do |config|
  config.token = 'xoxb-133313763122-OD2x8uk9A2UwjJ7SfTFmepzF'
end

client = Slack::Web::Client.new
channel = 'compose-events'

output = []

Dir.chdir('../website')

IO.popen("docker-compose events --json").each do |line|

  attr = compose_action_tmpl(JSON.parse(line))

  client.chat_postMessage(channel: channel, as_user: true, attachments: attr[:att])
  p line.chomp
  output << line.chomp
end

p output
