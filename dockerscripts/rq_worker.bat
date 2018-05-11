REM Start RQ-worker process. Override entrypoint so that rq-worker starts and not the web application
docker run --name rq-worker -d --rm -e SECRET_KEY=my-secret-key^
 -e MAIL_SERVER=smtp.googlemail.com -e MAIL_PORT=587 -e MAIL_USE_TLS=true^
 -e MAIL_USERNAME=nate.dhami@gmail.com -e MAIL_PASSWORD=natino123^
 --link mysql:dbserver --link redis:redis-server^
 -e DATABASE_URL=mysql+pymysql://microblog:db_pass@dbserver/microblog^
 -e REDIS_URL=redis://redis-server:6379/0^
 --entrypoint venv/bin/rq^
 microblog:latest worker -u redis://redis-server:6379/0 microblog-tasks