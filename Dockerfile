FROM php:alpine
MAINTAINER Paul Hutchinson

# Dependancies
RUN apk add --update git zip unzip openssh-client && \
    docker-php-ext-install pdo pdo_mysql pcntl && \
    rm -rf /usr/src/

# Add composer (v1.4.2)
RUN php -r "copy('https://raw.githubusercontent.com/composer/getcomposer.org/a488222dad0b6eaaa211ed9a21f016bb706b2980/web/installer', 'composer-setup.php');" \
        && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); die(1); } echo PHP_EOL;" \
        && php composer-setup.php \
        && php -r "unlink('composer-setup.php');" \
        && mv composer.phar /usr/bin/composer \

        # Make composer faster
        && composer global require hirak/prestissimo --no-progress \
        && composer global clear-cache

# Make Project directory
RUN mkdir -p /app/
WORKDIR /app/

# Copy Project
COPY composer.* /app/

# Run Composer (no autoloader or scripts)
RUN composer update --no-autoloader --no-scripts --no-progress --no-dev
RUN composer install --no-autoloader --no-scripts --no-progress --no-dev && \
    find -type d -name Tests -exec rm -rf {} + && \
    composer clear-cache

# Copy the files
COPY ./app /app/app
COPY ./src /app/src
COPY ./web /app/web
COPY ./bin /app/bin

# Run Composer again (as we now have the files)
RUN composer dumpautoload -o

CMD ./bin/console server:run 0.0.0.0:80

# Cleanup (this can be removed in dev)
#RUN rm /usr/bin/composer && \
#    apk del git zip unzip openssh-client
