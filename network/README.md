### Init weave server:

```bash
sudo weave_pswd=YOUR_PASSWORD chef-solo -c solo.rb -j server.json
```

 
### Connect to weave server:

```bash
sudo server_ip=SERVER_IP weave_pswd=YOUR_PASSWORD chef-solo -c solo.rb -j node.json
```

This will setup weave systemd services both on server and client machines. 


---  

- Old  
~`sudo server_ip=SERVER_IP overlay_client_ip=YOUR_OVERLAY_IP weave_pswd=YOUR_PASSWORD chef-solo -c solo.rb -j node.json`~

