FROM centos:7

RUN cd ~; \
    echo "[1] Import keys"; \
    rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7; \
    rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7; \
    rpm --import https://rpms.remirepo.net/RPM-GPG-KEY-remi; \
    echo "[2] Install epel repository"; \
    yum install epel-release wget net-tools iproute -y; \
    echo "[3] Install remi repository"; \
    wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm; \
    rpm -Uvh remi-release-7.rpm; \
    rm -f remi-release-7.rpm; \
    echo "[4] Update system"; \
    yum update -y;\
    echo "[5] Install php71"; \
    yum install php71 php71-php-bcmath php71-php-pecl-mongodb php71-php-mbstring git zip unzip mc nano htop -y; \
    ln -s /usr/bin/php71 /usr/bin/php; \
    ln -s /usr/bin/php71-cgi /usr/bin/php-cgi; \
    echo "[6] Install composer"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; exit(0); } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(-1); } echo PHP_EOL;" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv ~/composer.phar /usr/bin/composer; \
    echo "[2] Clean yum cache"; \
    yum clean all; \
    rm -rf /var/cache/yum

