FROM debian:bullseye

# MariaDBのインストール
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# MariaDBの設定
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# 初期化スクリプトをコピー
COPY ./conf/init.sql /docker-entrypoint-initdb.d/
COPY ./conf/my.cnf /etc/mysql/my.cnf

# 初期化スクリプト
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# MariaDBを起動
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld", "--bind-address=0.0.0.0"]



