# Install Freeswitch


Download image:
```
docker pull bayrell/freeswitch
```


Create data volume:
```
docker volume create freeswitch_data
```


Create network:
```
docker network create -d bridge --subnet=172.20.0.0/16 mynetwork -o "com.docker.network.bridge.name"="mynetwork"
iptables -t nat -A POSTROUTING -s 172.20.10.50/32 -d 172.20.10.50/32 -p tcp -m tcp --dport 16384:32768 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.20.10.50/32 -d 172.20.10.50/32 -p udp -m udp --dport 16384:32768 -j MASQUERADE
iptables -t filter -A DOCKER -d 172.20.10.50/32 ! -i mynetwork -o mynetwork -p tcp -m tcp --dport 16384:32768 -j ACCEPT
iptables -t filter -A DOCKER -d 172.20.10.50/32 ! -i mynetwork -o mynetwork -p udp -m udp --dport 16384:32768 -j ACCEPT
```


Run container
```
docker run -it -d --name freeswitch -v freeswitch_data:/data -p 80:80 -p 5060:5060 -p 5060:5060/udp -p 5080:5080 -p 5080:5080/udp --ip=172.20.10.50 --network="mynetwork" --restart=unless-stopped bayrell/freeswitch:stage1
```


**Default PostgreSQL settings:**

```
Host: locahost
User: fusionpbx
Password: psqlpassword
Database: fusionpbx
```