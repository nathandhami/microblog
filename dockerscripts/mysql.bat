docker run --name mysql -d -e MYSQL_RANDOM_ROOT_PASSWORD=yes^
 -e MYSQL_DATABASE=microblog -e MYSQL_USER=microblog -e MYSQL_PASSWORD=db_pass^
  mysql/mysql-server:5.7