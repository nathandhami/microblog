REM  docker run --name microblog -d -p 8000:5000 --rm -e SECRET_KEY=my-secret-key^
REM  -e MAIL_SERVER=smtp.googlemail.com -e MAIL_PORT=587 -e MAIL_USE_TLS=true^
REM  -e MAIL_USERNAME=<your-gmail-username> -e MAIL_PASSWORD=<your-gmail-password>^
REM  --link mysql:dbserver^
REM  -e DATABASE_URL=mysql+pymysql://microblog:db_pass>@dbserver/microblog^
REM  microblog:latest
@echo off
docker run --name microblog -d -p 8000:5000 --rm -e SECRET_KEY=my-secret-key^
 --link mysql:dbserver^
 -e DATABASE_URL=mysql+pymysql://microblog:db_pass@dbserver/microblog^
 --link elasticsearch:elasticsearch^
 -e ELASTICSEARCH_URL=http://elasticsearch:9200^
 microblog:latest