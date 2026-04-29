FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY conf/nginx.crt /etc/ssl/certs/nginx.crt
COPY conf/nginx.key /etc/ssl/private/nginx.key

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]