FROM debian:bullseye

# PHP 8.2リポジトリの追加
RUN apt-get update && apt-get install -y \
    lsb-release \
    ca-certificates \
    curl \
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-zip \
    wget \
    mariadb-client \
    curl \
    less \
    && rm -rf /var/lib/apt/lists/*

# php-fpmの設定
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.2/fpm/pool.d/www.conf

# WordPressのセットアップ
WORKDIR /var/www/html

# WP-CLIのインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# セットアップスクリプトの追加
COPY ./tools/wordpress-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-setup.sh

# セットアップスクリプトを実行
CMD ["/usr/local/bin/wordpress-setup.sh"]

