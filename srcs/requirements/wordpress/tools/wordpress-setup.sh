#!/bin/bash

# MariaDBが起動するまで待機
while ! mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 3
done

# WP-CLIのダウンロードとインストール
if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# WordPressのコアファイルが存在するか確認
if [ ! -f "/var/www/html/index.php" ]; then
    wp core download --allow-root
fi

# wp-config.phpが存在しない場合のみ設定を作成
if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --path="/var/www/html"

    # WordPressのインストール
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception WordPress" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}"

    # 通常ユーザーの作成
    wp user create --allow-root \
        "${WORDPRESS_REGULAR_USER}" \
        "${WORDPRESS_REGULAR_EMAIL}" \
        --role=author \
        --user_pass="${WORDPRESS_REGULAR_PASSWORD}"
fi

# 所有者とパーミッションの設定
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# PHP-FPMの起動
exec php-fpm8.2 -F 