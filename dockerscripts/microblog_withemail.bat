@echo off
docker run --name microblog -d -p 8000:5000 --rm -e SECRET_KEY=my-secret-key^
 -e MAIL_SERVER=smtp.googlemail.com -e MAIL_PORT=587 -e MAIL_USE_TLS=true^
 -e MAIL_USERNAME=nate.dhami@gmail.com -e MAIL_PASSWORD=natino123^
 --link mysql:dbserver --link redis:redis-server --link elasticsearch:elasticsearch^
 -e DATABASE_URL=mysql+pymysql://microblog:db_pass@dbserver/microblog^
 -e REDIS_URL=redis://redis-server:6379/0^
 microblog:latest