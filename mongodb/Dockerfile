FROM mongo:3.6.1-jessie

COPY root/run.sh /root/run.sh

RUN cd ~; \
	export DEBIAN_FRONTEND=noninteractive; \
	apt update; \
	apt install net-tools iproute curl mc nano less dnsutils iputils-ping -y

CMD ["/root/run.sh"]
