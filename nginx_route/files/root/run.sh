#!/bin/bash


# Run consul loop service register
/root/consul.sh &


rm -f /var/run/supervisor/supervisor.sock
/usr/bin/supervisord -c /etc/supervisord.conf -n
