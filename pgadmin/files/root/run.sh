#!/bin/bash


# Run supervisor
rm -f /var/run/supervisor/supervisor.sock
/usr/bin/supervisord -c /etc/supervisord.conf -n
