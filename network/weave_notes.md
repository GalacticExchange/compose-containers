


### Weave Net setup

On host_1:

```bash
weave launch --ipalloc-range x.x.x.x/y --password YOUR_PASSWORD
```


On host_2:

```bash
weave launch $HOST_1_IP --ipalloc-range x.x.x.x/y --password YOUR_PASSWORD
``` 