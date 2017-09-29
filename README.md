## gex-compose repo

This is docker-compose based system used to build and deploy `gex [1]` containers on a multiple hosts.

#### Main parts

- **registry** - image storage (docker-registry + nginx) (Status: in progress)
- **network** - multi-host docker-compose setup (Status: in progress)
  
  
- **website** (Status: in progress)
- **core** (Status: in progress)
- **logs** (Status: todo)



#### 





##### Reference

1. `gex container` -  our internal container










# TODO part....
Rebuild a single service:
``` 
  docker-compose build --no-cache  app
```

Stream compose events:

```bash
 docker-compose events
```





### Setup Swarm

Switch Docker to a Swarm mode:
``` 
    docker swarm init 
```

Add Swarm nodes:
``` 
docker swarm join \
   --token TOKEN_GOES_HERE \
   master_node_ip:2377
```



### Deploy images to Registry:


``` 
docker login dockerhub.gex:5043
> gex
> PH_GEX_PASSWD1

docker-compose up --build

docker-compose down --volumes

docker-compose push
```


### Deploy the stack to the swarm

``` 
docker stack deploy --compose-file docker-compose.yml stackdemo
```


### Stuff

https://docs.docker.com/engine/swarm/swarm-tutorial/inspect-service/

```

######

docker info

docker node ls


#######

docker service create --replicas 1 --name helloworld alpine ping docker.com

docker service inspect --pretty helloworld

docker service ps helloworld

docker service scale helloworld=5

#######
docker service rm helloworld
```

### Docker stack commamds 

https://docs.docker.com/engine/reference/commandline/stack_deploy/#parent-command
``` 
docker stack deploy	          Deploy a new stack or update an existing stack
docker stack ls	              List stacks
docker stack ps	              List the tasks in the stack
docker stack rm	              Remove one or more stacks
docker stack services	      List the services in the stack
```


https://dockerhub.gex:5043/v2/_catalog



Filter containers by labels: 

``` 
docker ps -f label=com.gex.version=0.1
```

Filter by project:
```
docker ps -f label=com.docker.compose.project=website
```
