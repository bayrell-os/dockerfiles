# Install Freeswitch


Download image:
```
docker pull bayrell/freeswitch
```


Create data volume:
```
docker volume create freeswitch_data
```


Run container
```
docker run -it -d --name freeswitch -v freeswitch_data:/data bayrell/freeswitch
```




