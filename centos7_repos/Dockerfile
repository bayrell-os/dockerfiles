FROM centos:7

RUN cd ~; \
    echo "[1] Import keys"; \
    rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7; \
    rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7; \
    rpm --import https://rpms.remirepo.net/RPM-GPG-KEY-remi; \
    echo "[2] Install epel repository"; \
    yum update -y;\
    yum install epel-release wget -y; \
    echo "[3] Install remi repository"; \
    wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm; \
    rpm -Uvh remi-release-7.rpm; \
    rm -f remi-release-7.rpm; \
    echo "[4] Clean yum cache"; \
    yum clean all; \
    rm -rf /var/cache/yum

