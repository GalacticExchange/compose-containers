## Build system

Build system used to build complex containers for the gex-compose service.


##### Projects

- core
- logs
- website

#### How to add new container to project

1) 

2) 

3)


**Rebuild one containers:**
```
rake build:image[project,app,main,0.1]
```

**Rebuild all containers:**
```
rake build:all[project,main,0.1]
```


#### Packer


packer-config gem used to generate packer config via Ruby: https://github.com/ianchesal/packer-config


Setup build machine:

```
gem install packer-config
```

