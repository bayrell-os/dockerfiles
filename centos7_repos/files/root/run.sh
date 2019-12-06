#!/bin/bash

export EDITOR=nano

# Run scripts
if [ -d /root/run.d ]; then
  for i in /root/run.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# Run supervisor
rm -f /var/run/supervisor/supervisor.sock
/usr/bin/supervisord -c /etc/supervisord.conf -n
