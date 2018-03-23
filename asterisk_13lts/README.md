# Install Asterisk


Download image:
```
docker pull bayrell/asterisk_13lts
```


Create data volume:
```
docker volume create asterisk_data
```


Run container:
```
docker run -it -d --name asterisk -v asterisk_data:/data -p 80:80 -p 4569:4569/tcp -p 4569:4569/udp -p 5060:5060/tcp -p 5060:5060/udp -p 5160:5160/tcp -p 5160:5160/udp -p 10000-20000:10000/udp bayrell/asterisk_13lts
docker exec asterisk fwconsole ma install sipsettings
docker exec asterisk fwconsole ma enable sipsettings
```


Wait 5 minutes


Check the container:
```
docker exec -it work /usr/bin/supervisorctl status
```

Must be output:
```
dbus                             RUNNING   pid 57, uptime 0:02:11
httpd                            RUNNING   pid 60, uptime 0:02:11
mysqld                           RUNNING   pid 58, uptime 0:02:11
php-fpm                          RUNNING   pid 59, uptime 0:02:11
```

Enable freepbx modules:

```
docker exec work fwconsole ma install sipsettings
docker exec work fwconsole ma enable sipsettings
```


Install modules in the FreePBX Admin Panel:


