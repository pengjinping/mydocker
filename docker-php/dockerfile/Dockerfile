FROM php:7.2.4-fpm-stretch

LABEL maintainer="lestat@lestat.me"

# 安装 nginx
RUN apt-get update && apt-get install nginx -y && apt-get install vim -y

# Copy existing application directory contents
COPY index.php /var/www/html
COPY default.conf /etc/nginx/conf.d/

RUN rm /usr/local/etc/php-fpm.d/zz-docker.conf

# nginx 自动启动
ENTRYPOINT ["nginx","-g","daemon off;"]