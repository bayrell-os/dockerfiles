FROM rabbitmq:3.6.14-management

COPY root/run.sh /root/run.sh
ADD etc/rabbitmq /etc/rabbitmq/

RUN cd ~; \
	export DEBIAN_FRONTEND=noninteractive; \
	apt update; \
	apt install net-tools iproute curl mc nano less dnsutils iputils-ping -y

CMD ["/root/run.sh"]
