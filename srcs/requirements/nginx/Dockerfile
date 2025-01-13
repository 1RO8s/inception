FROM debian:stable

RUN apt-get update && apt-get install -y nginx procps openssl net-tools

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=localhost"


RUN rm -f /etc/nginx/sites-enabled/default
COPY ./conf/default /etc/nginx/sites-enabled/default
# COPY ./conf/conf.d /etc/nginx/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
