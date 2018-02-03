FROM centos:7

RUN cd ~; \
    echo "[1] Import keys"; \
    rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7; \
    echo "[2] Download consul"; \
    yum install unzip wget -y; \
    wget https://releases.hashicorp.com/consul/1.0.3/consul_1.0.3_linux_amd64.zip; \
    echo "[3] Install consul"; \
    unzip ./consul_1.0.3_linux_amd64.zip; \
    mv ./consul /usr/bin/consul; \
    chmod +x /usr/bin/consul; \
    mkdir -p /var/lib/consul/data; \
    rm -f ./consul_1.0.3_linux_amd64.zip; \
    echo "[4] Update system and clean cache"; \
    yum update -y; \
    yum clean all; \
    rm -rf /var/cache/yum


