FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# SSL証明書の生成
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=Student/CN=hnagasak.42.fr"

# デフォルト設定の削除
RUN rm -f /etc/nginx/sites-enabled/default

# カスタム設定の追加
COPY ./conf/default /etc/nginx/sites-enabled/default

# Nginxを起動
CMD ["nginx", "-g", "daemon off;"]
