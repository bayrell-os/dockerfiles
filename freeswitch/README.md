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
docker run -it -d --name freeswitch -v freeswitch_data:/data -p 80:80 bayrell/freeswitch
```


*Default PostgreSQL settings:*
Host: locahost

User: fusionpbx

Password: pa$$word

Database: fusionpbx
