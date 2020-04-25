FROM alpine:latest

RUN cd ~; \
	echo "" > /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.9/main" >> /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.9/community" >> /etc/apk/repositories; \
	apk update; \
	apk add bash nano mc wget net-tools pv zip unzip supervisor procps grep; \
	rm -rf /var/cache/apk/*; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"

ADD files /src/files
RUN cd ~; \
	mkdir -p /data; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo "Ok"

CMD ["/root/run.sh"]