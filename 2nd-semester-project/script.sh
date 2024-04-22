#!/bin/bash

# Add Ondřej Surý's PPA for PHP

    echo_task "Adding Ondřej Surý's PPA for PHP"
    sudo add-apt-repository -y ppa:ondrej/php

# Update package index
    sudo apt update

# Install MySQL Server
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
    sudo apt-get -y install mysql-server

# Set Default PHP version
    sudo update-alternatives --set php /usr/bin/php8.2
    sudo a2enmod php8.2

# Clone Laravel repository
    sudo chmod 777 /var/www/html
    cd /var/www/html 
    git clone https://github.com/laravel/laravel.git
    cd /var/www/html/laravel

# Install Composer (Dependency Manager for PHP)

    sudo apt install -y composer

# Upgrade Composer 
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir /usr/bin --filename composer

# Install Laravel dependencies with Composer
    export COMPOSER_ALLOW_SUPERUSER=1
    sudo -S <<< "yes" composer install

# Settung permissions for Laravel directories
    sudo chown -R www-data:www-data /var/www/html/laravel/storage /var/www/html/laravel/bootstrap/cache
    sudo chmod -R 775 /var/www/html/laravel/storage/logs

# Setting up Apache Virtual to host Laravel
    sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env
    sudo chown www-data:www-data /var/www/html/laravel/.env
    sudo chmod 640 /var/www/html/laravel/.env
# configuring your site available to laravel.conf
    cd /etc/apache2/sites-available/laravel.conf
    sudo tee /etc/apache2/sites-available/laravel.conf >/dev/null <<EOF
<VirtualHost *:80>
    ServerName 192.168.1.20
    ServerAlias *
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
        AllowOverride All
    </Directory>
</VirtualHost>
EOF


# configuring Laravel, generating key and othter things
    sudo php /var/www/html/laravel/artisan key:generate
    sudo php /var/www/html/laravel/artisan migrate --force

    echo_task "Setting permissions for Laravel Database"
    sudo chown -R www-data:www-data /var/www/html/laravel/database/
    sudo chmod -R 775 /var/www/html/laravel/database/

# configurations for apache 
    sudo a2query -s 000-default.conf
    sudo a2dissite 000-default.conf

    sudo a2query -s laravel.conf
    sudo a2ensite laravel.conf

    sudo systemctl reload apache2


    echo "PHP LARAVEL APPLICATION DEPLOYMENT COMPLETE!"