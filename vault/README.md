# Vault

### Start

```bash
    docker-compose up -d
```


### Setup Vault

1) Go into container

```bash
    docker exec -it vault_vault_1 sh

    vault status
    Error checking seal status: Error making API request.
    
    URL: GET http://127.0.0.1:8200/v1/sys/seal-status
    Code: 400. Errors:
    
    * server is not yet initialized
```

2) Init


```bash
    $ vault init
    Unseal Key 1: 
    Unseal Key 2: 
    Unseal Key 3: 
    Unseal Key 4: 
    Unseal Key 5: 
    Initial Root Token: 
```

3) Unseal

Run (with 3 unseal keys):

``` 
    vault unseal
```

4) Auth

``` 
    vault auth
```