FROM php:8.3-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    curl \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Configurar el directorio de trabajo
WORKDIR /var/www

# Copiar los archivos de composer primero para aprovechar la cache
COPY composer.json composer.lock ./

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependencias de PHP
RUN composer install --no-autoloader --no-scripts

# Copiar el resto del código fuente
COPY . .

# Ejecutar autoloader de Composer
RUN composer dump-autoload

# Ajustar permisos (puedes ajustar el usuario según sea necesario)
RUN chown -R www-data:www-data storage bootstrap/cache

# Expone el puerto
EXPOSE 9000

# Comando para iniciar PHP-FPM
CMD ["php-fpm"]
