#!/bin/bash

# MariaDBが起動するまで待機
until mysql -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1"; do
    echo "Waiting for MariaDB to be ready..."
    sleep 3
done

# WordPressディレクトリの所有者を設定
chown -R www-data:www-data /var/www/html

# WP-CLIのダウンロードとインストール
if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

cd /var/www/html

# WordPressのコアファイルが存在するか確認
if [ ! -f "index.php" ]; then
    wp core download --allow-root
fi

# wp-config.phpが存在しない場合のみ設定を作成
if [ ! -f "wp-config.php" ]; then
    # 設定ファイルの作成
    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --dbcharset="utf8mb4"

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

# PHP-FPMの起動
exec php-fpm8.2 -F 