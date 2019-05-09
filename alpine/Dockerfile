FROM alpine:latest

RUN cd ~; \
	echo "" > /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.9/main" >> /etc/apk/repositories; \
	echo "https://mirror.yandex.ru/mirrors/alpine/v3.9/community" >> /etc/apk/repositories; \
	apk update; \
	apk add bash nano mc wget; \
	echo "export EDITOR=nano" > /etc/profile.d/editor_nano; \
	echo "Ok"


CMD ["bash"]
