Based on: https://luppeng.wordpress.com/2016/05/03/setting-up-an-overlay-network-on-docker-without-swarm/


### Network

We need a global docker network in order to communicate between docker-compose setups on a different hosts

##### Step 1: Run Consul (as a key-value storage for docker)

```
### todo
```

##### Step 2: Edit docker configuration (on each docker host)

Edit `/etc/default/docker`
```
DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-advertise eno1:2375 --cluster-store consul://10.1.0.18:8500"
```

Edit `/lib/systemd/system/docker.service`  
Add EnvironmentFile line, then add $DOCKER_OPTS to the next line:

```
EnvironmentFile=/etc/default/docker
ExecStart= ... $DOCKER_OPTS -H fd://
```


##### Step 3: Create docker network
```
docker network create -d overlay --subnet=20.1.0.0/16 test_net
```


Check network:
```
docker network inspect test_net
```

##### Other stuff


``` 
docker network disconnect -f test_net website-app
```