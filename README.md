# DS18b20 temperature readings via python and store them in Mysql
Setup gekregen van Jeroen en van http://iot-projects.com/index.php?id=connect-ds18b20-sensors-to-raspberry-pi

## Steps

Install MariaDB
create DB
Create users
Test db

Install 1Wire
Test ds18b20

Create website
Test PHP
Test PHP/Mysql
Test Json output
Test Amcharts

Ready


## Install MariaDB

```
gej@rpib2 ~/ds18b20-mysql $ sudo apt --assume-yes install mariadb-client mariadb-server
```

Je moet nu wel je "master" wachtwoord zetten voor de database.

Die moet je ook even in je .my.cnf zetten zodat je automatisch in kunt loggen.

```
gej@rpib2 ~/ds18b20-mysql $ vi ../.my.cnf
[client]
user=root
password=ErgMoeilijkWachtwoord890
```

## Create DB

Met een script
```
gej@rpib2 ~/ds18b20-mysql/db $ mysql temperature < create_db.sql 
ERROR 1049 (42000): Unknown database 'temperature'
gej@rpib2 ~/ds18b20-mysql/db $ mysql  < create_db.sql 
```

Create DB met de hand

```
gej@rpib2 ~/ds18b20-mysql $ sudo mysql -u root -p

CREATE DATABASE temperature;

USE temperature;
CREATE TABLE DS18B20( measurement_id INT NOT NULL AUTO_INCREMENT,
                      sensor_id INT NOT NULL,
                      date DATE NOT NULL,
                      time TIME NOT NULL,
                      value varchar(50),
                      PRIMARY KEY ( measurement_id ));
```


# Create DB User

Syntax:
GRANT INSERT,SELECT ON temperature.* TO 'temp_user1'@'localhost' IDENTIFIED BY 'pwd_user1';
FLUSH PRIVILEGES;

```
gej@rpib2 ~/ds18b20-mysql $ mysql -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 37
Server version: 10.0.27-MariaDB-0+deb8u1 (Raspbian)

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> GRANT INSERT,SELECT ON temperature.* TO 'temp_user1'@'localhost' IDENTIFIED BY 'pwd_user1';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> 
```

## Test DB

```
gej@rpib2 ~/ds18b20-mysql $ python sen2db.py 
Traceback (most recent call last):
  File "sen2db.py", line 5, in <module>
    import MySQLdb as mdb
ImportError: No module named MySQLdb
gej@rpib2 ~/ds18b20-mysql $
```

Oh jee, error, even mysql-python installeren

```
gej@rpib2 ~/ds18b20-mysql $ sudo apt install python-mysqldb
```

# Controle DB
```
gej@rpib2 ~/ds18b20-mysql $ mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 39
Server version: 10.0.27-MariaDB-0+deb8u1 (Raspbian)

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| temperature        |
+--------------------+
5 rows in set (0.00 sec)

MariaDB [(none)]> use temperature
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [temperature]> show tables;
+-----------------------+
| Tables_in_temperature |
+-----------------------+
| sensor_names          |
| temp_log              |
+-----------------------+
2 rows in set (0.00 sec)

MariaDB [temperature]> select * from temp_log;
+----------------+-----------------+------------+----------+------------+-------+-----------+
| measurement_id | sensor_id       | date       | time     | timestamp  | value | value_int |
+----------------+-----------------+------------+----------+------------+-------+-----------+
|         181135 | 28-0215635672ff | 2016-10-02 | 14:35:00 | 1475411700 | 23.5  |     23500 |
+----------------+-----------------+------------+----------+------------+-------+-----------+
1 row in set (0.00 sec)

MariaDB [temperature]> 
```

Dit kan natuurlijk ook met een oneliner:

```
gej@rpib2 ~/ds18b20-mysql $ mysql -e  "select * from temp_log;" temperature
+----------------+-----------------+------------+----------+------------+-------+-----------+
| measurement_id | sensor_id       | date       | time     | timestamp  | value | value_int |
+----------------+-----------------+------------+----------+------------+-------+-----------+
|         181135 | 28-0215635672ff | 2016-10-02 | 14:35:00 | 1475411700 | 23.5  |     23500 |
|         181136 | 28-0215635672ff | 2016-10-02 | 14:39:00 | 1475411900 | 23.5  |     23500 |
|         181137 | 28-0215635672ff | 2016-10-02 | 14:45:00 | 1475412300 | 23.5  |     23500 |
+----------------+-----------------+------------+----------+------------+-------+-----------+
gej@rpib2 ~/ds18b20-mysql $
```


# Crontab

automatiseren dat elke 5 minuten het python script draait
(het pad naar je python script zal voor iedereen anders zijn)
```
gej@rpib2 ~/ds18b20-mysql $ crontab -e
```
*/5 * * * *     /usr/bin/python /home/gej/ds18b20-mysql/sen2db.py

