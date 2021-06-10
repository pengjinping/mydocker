FROM daocloud.io/php:7.2-fpm-alpine

LABEL maintainer="lestat@lestat.me"

ENV PHPREDIS_VERSION 4.2.0
# 修改镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装依赖,核心扩展,pecl扩展,git
RUN apk update && apk upgrade \
    && apk add --no-cache bash bash-doc bash-completion \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS curl-dev imagemagick-dev libtool \
        libxml2-dev postgresql-dev sqlite-dev libmcrypt-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev \
    && apk add --no-cache curl git tzdata openrc supervisor imagemagick mysql-client postgresql-libs \
    && pecl install imagick \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt imagick \
    && docker-php-ext-install curl mbstring mysqli pdo pdo_mysql pdo_pgsql pdo_sqlite pcntl tokenizer xml zip \
	&& docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd \
    && pecl install -o -f redis \
    && pecl install swoole \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis swoole

# 字符编码支持utf-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 安装composer并允许root用户运行 配置全量镜像
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_HOME=/usr/local/share/composer
RUN mkdir -p /usr/local/share/composer \
	&& curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
	&& php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
	&& rm -f /tmp/composer-setup.* \
    # 配置composer中国全量镜像
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

#配置supervisor
COPY supervisor/supervisord.conf /etc/supervisord.conf

# 启动crontab
ADD ./crontab /etc/cron.d/root
RUN chmod 0644 /etc/cron.d/root

ENTRYPOINT ["/usr/sbin/crond", "-f", "-c", "/etc/cron.d"]
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
