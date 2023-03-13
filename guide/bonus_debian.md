# Born2beroot Bonuses

For the Born2beroot bonuses, we have to install WordPress with Lighttpd, MariaDB and PHP. We also have to install another service of our own choice, and justify that choice.

There is a [VM installation guide](https://github.com/mcombeau/Born2beroot/blob/main/guide/installation_debian.md) and a [configuration guide](https://github.com/mcombeau/Born2beroot/blob/main/guide/configuration_debian.md), as well.

## Installing WordPress

### Installing PHP

To get the latest version of PHP (8.1 at the time of this writing), we need to add a different APT repository, Sury's repository.

```bash
$ sudo apt update
$ sudo apt install curl
$ sudo curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
$ sudo apt update 
```

Install PHP version 8.1:
```bash
$ sudo apt install php8.1
$ sudo apt install php-common php-cgi php-cli php-mysql
```

Check php version:
```bash
$ php -v
```

### Installing Lighttpd

Apache may be installed due to PHP dependencies. Uninstall it if it is to avoid conflicts with lighttpd:

```bash
$ systemctl status apache2
$ sudo apt purge apache2
```

Install lighttpd:

```bash
$ sudo apt install lighttpd
```

Chack version, start, enable lighttpd and check status:

```bash
$ sudo lighttpd -v
$ sudo systemctl start lighttpd
$ sudo systemctl enable lighttpd
$ sudo systemctl status lighttpd
```

Next, allow http port (port 80) through UFW:
```bash
$ sudo ufw allow http
$ sudo ufw status
```

And forward host port 8080 to guest port 80 in VirtualBox:

* Go to VM >> ```Settings``` >> ```Network``` >> ```Adapter 1``` >> ```Port Forwarding```
* Add rule for host port ```8080``` to forward to guest port ```80```

To test Lighttpd, go to host machine browser and type in address ```http://127.0.0.1:8080``` or ```http://localhost:8080```. You should see a Lighttpd "placeholder page".

Back in VM, activate lighttpd FastCGI module:
```bash
$ sudo lighty-enable-mod fastcgi
$ sudo lighty-enable-mod fastcgi-php
$ sudo service lighttpd force-reload
```

To test php is working with lighttpd, create a file in ```/var/www/html``` named ```info.php```. In that php file, write:
```php
<?php
phpinfo();
?>
```

Save and go to host browser and type in the address ```http://127.0.0.1:8080/info.php```. You should get a page with PHP information.

### Installing MariaDB

Install MariaDB:
```bash
$ sudo apt install mariadb-server
```

Start, enable and check MariaDB status:
```bash
$ sudo systemctl start mariadb
$ sudo systemctl enable mariadb
$ systemctl status mariadb
```

Then do the MySQL secure installation:
```bash
$ sudo mysql_secure_installation
```

Answer the questions like so (root here does not mean root user of VM, it's the root user of the databases!):
```
Enter current password for root (enter for none): <Enter>
Switch to unix_socket authentication [Y/n]: Y
Set root password? [Y/n]: Y
New password: 101Asterix!
Re-enter new password: 101Asterix!
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]:  Y
Reload privilege tables now? [Y/n]:  Y
```

Restart MariaDB service:
```bash
$ sudo systemctl restart mariadb
```

Enter MariaDB interface:
```bash
$ mysql -u root -p
```

Enter MariaDB root password, then create a database for WordPress:
```mysql
MariaDB [(none)]> CREATE DATABASE wordpress_db;
MariaDB [(none)]> CREATE USER 'admin'@'localhost' IDENTIFIED BY 'WPpassw0rd';
MariaDB [(none)]> GRANT ALL ON wordpress_db.* TO 'admin'@'localhost' IDENTIFIED BY 'WPpassw0rd' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;
```

Check that the database was created successfully, go back into MariaDB interface:
```bash
$ mysql -u root -p
```

And show databases:
```mysql
MariaDB [(none)]> show databases;
```

You should see something like this:
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| wordpress_db       |
+--------------------+
```
If the database is there, everything's good!

### Installing WordPress

We need to install two tools:
```bash
$ sudo apt install wget
$ sudo apt install tar
```

Then download the latest version of Wordpress, extract it and place the contents in ```/var/www/html/``` directory. Then clean up archive and extraction directory:
```bash
$ wget http://wordpress.org/latest.tar.gz
$ tar -xzvf latest.tar.gz
$ sudo mv wordpress/* /var/www/html/
$ rm -rf latest.tar.gz wordpress/
```

Create WordPress configuration file:
```bash
$ sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```

Edit ```/var/www/html/wp-config.php``` with database info:
```php
<?php
/* ... */
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_db' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'WPpassw0rd' );

/** Database host */
define( 'DB_HOST', 'localhost' );
```

Change permissions of WordPress directory to grant rights to web server and restart lighttpd:
```bash
$ sudo chown -R www-data:www-data /var/www/html/
$ sudo chmod -R 755 /var/www/html/
$ sudo systemctl restart lighttpd
```

In host browser, connect to ```http://127.0.0.1:8080``` and finish WordPress installation.

## Installing Fail2ban
For the second bonus, I chose to install Fail2ban as a security measure for SSH against brute force attacks.

Install Fail2ban:
```bash
$ sudo apt install fail2ban
$ sudo systemctl start fail2ban
$ sudo systemctl enable fail2ban

$ sudo systemctl status fail2ban
```

Create ```/etc/fail2ban/jail.local``` local cofiguration file.
```bash
$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

Edit ```/etc/fail2ban/jail.local```, find line ~279 the "SSH servers" heading and modify [sshd] configurations like this:
```
[sshd]

# To use more aggressive sshd modes set filter parameter "mode" in jail.local:
# normal (default), ddos, extra or aggressive (combines all).
# See "tests/files/logs/sshd" or "filter.d/sshd.conf" for usage example and details.
# mode   = normal
enabled  = true
maxretry = 3
findtime = 10m
bantime  = 1d
port     = 4242
logpath  = %(sshd_log)s
backend  = %(sshd_backend)s
```

Restart Fail2ban:
```bash
$ sudo systemctl restart fail2ban
```

To check failed connection attempts and banned IP addresses, use these commands:
```bash
$ sudo fail2ban-client status
$ sudo fail2ban-client status sshd
$ sudo tail -f /var/log/fail2ban.log
```

Test by setting a low value ```bantime``` (like 10m) in ```/etc/fail2ban/jail.local``` sshd settings, and try to connect multiple times via SSH with the wrong password to get banned.

---
Made by mcombeau: mcombeau@student.42.fr | LinkedIn: [mcombeau](https://www.linkedin.com/in/mia-combeau-86653420b/) | Website: [codequoi.com](https://www.codequoi.com)
