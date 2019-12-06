printenv | sed 's/^\(.*\)$/export \1/g' > /root/env.sh
chmod +x /root/env.sh
