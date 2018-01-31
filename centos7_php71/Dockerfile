FROM bayrell/centos7_repos:latest

RUN cd ~; \
    echo "[1] Update core system"; \
    yum update -y; \
    echo "[2] Install php71"; \
    yum install php71 -y; \
    ln -s /usr/bin/php71 /usr/bin/php; \
    ln -s /usr/bin/php71-cgi /usr/bin/php-cgi; \
    echo "[3] Install composer"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; exit(0); } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(-1); } echo PHP_EOL;" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv ~/composer.phar /usr/bin/composer; \
    echo "[4] Clean yum cache"; \
    yum clean all; \
    rm -rv /var/cache/yum

