# Usage

Images in registry: https://dockerhub.gex:5043/v2/_catalog

``` 
https://gex:PH_GEX_PASSWD1@dockerhub.gex:5043/v2/
curl -k https://gex:PH_GEX_PASSWD1@dockerhub.gex:5043/v2/
```

Manually pull from private registry:
```
docker login dockerhub.gex:5043
> gex
> PH_GEX_PASSWD1

docker pull dockerhub.gex:5043/app
```



# Setup

Original: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04



### Setting Up Authentication

- Run `install_cert_local.sh`


- Add user 
```
    cd ./containers/nginx
    htpasswd -c registry.password USERNAME
    
    username: gex
    password: PH_GEX_PASSWD1
```

- Uncomment those lines:
```
# auth_basic "registry.localhost";
# auth_basic_user_file /etc/nginx/conf.d/registry.password;
# add_header 'Docker-Distribution-Api-Version' 'registry/2.0' always;
```

- Uncomment this:

```
# ssl on;
# ssl_certificate /etc/nginx/conf.d/domain.crt;
# ssl_certificate_key /etc/nginx/conf.d/domain.key;
```

- Change server_name in the `registry.conf`
