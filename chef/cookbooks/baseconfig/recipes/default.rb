# Make sure the Apt package lists are up to date, so we're downloading versions that exist.
cookbook_file "apt-sources.list" do
  path "/etc/apt/sources.list"
end
execute 'apt_update' do
  command 'apt-get update'
end

# ######## Base configuration recipe in Chef ########

package "wget"
package "ntp"
package "python-software-properties"
package "python-pip"


# ######## NTP Config ########

cookbook_file "ntp.conf" do
  path "/etc/ntp.conf"
end

execute 'ntp_restart' do
  command 'service ntp restart'
end

# SSH Configuration: disable root and password logins
cookbook_file "sshd_config" do
  command '/etc/ssh/sshd_config'
end

execute 'sshd_restart' do
  command 'service ssh restart'
end

# Firewall setup
bash 'firewall_setup' do
  code <<-EOH
  sudo apt-get install -y ufw
  sudo ufw allow ssh
  sudo ufw allow http
  sudo ufw allow 443/tcp
  sudo ufw --force enable
  sudo ufw status
  EOH
end

# Installing Base Dependencies
bash 'install_base_dependencies' do
  code <<-EOH
  sudo apt-get -y update
  sudo apt-get -y install python3 python3-venv python3-dev
  sudo apt-get -y install mysql-server postfix supervisor git
  EOH
end

# Create virtual environment & setup
bash 'create_environment' do
  code <<-EOH
  cd ~
  cp -r project project_linux
  rm -rf project_linux/venv
  cd project_linux
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  pip install gunicorn pymysql
  echo "export FLASK_APP=microblog.py" >> ~/.profile
  flask translate compile
  EOH
end

# Setup MySQL
bash 'setup_mysql' do
  code <<-EOH
  mysql -u root --password=pass
  create database microblog character set utf8 collate utf8_bin;
  create user 'microblog'@'localhost' identified by 'db_pass';
  grant all privileges on microblog.* to 'microblog'@'localhost';
  flush privileges;
  quit;
  flask db upgrade
  EOH
end

# Supervisor config
cookbook_file 'microblog.conf' do
  command '/etc/supervisor/conf.d/'
end

execute 'supervisor_restart' do
  command 'supervisorctl reload'
end

# check status with sudo supervisorctl status microblog


#Create  SSL certificate
bash 'create_ssl' do
  code <<-EOH
  cd ~/project_linux
  mkdir certs
  openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout certs/key.pem -out certs/cert.pem
  EOH
end

# ######## NGINX Config ########

# package "nginx"
cookbook_file "nginx-microblog" do
  path "/etc/nginx/sites-available/"
end

bash 'nginx_setup' do
  code <<-EOH
  cd /etc/nginx/sites-enabled/
  sudo rm default
  sudo ln -s /etc/nginx/sites-available/nginx-microblog nginx-microblog
  EOH
end

service "nginx" do
	action :restart
end

# steps to update application
# (venv) $ git pull                              # download the new version
# (venv) $ sudo supervisorctl stop microblog     # stop the current server
# (venv) $ flask db upgrade                      # upgrade the database
# (venv) $ flask translate compile               # upgrade the translations
# (venv) $ sudo supervisorctl start microblog    # start a new server

# ######## Nodejs Config ########

# execute 'curl-npm' do
#   command 'curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -'
# end

# package "nodejs"


# bash 'npm_global_installation' do
#   code <<-EOH
#   sudo npm install -g node-pre-gyp 
#   sudo npm install -g bower
#   sudo npm install -g pm2
#   EOH
# end


# bash 'install_dependencies' do
#   cwd '/home/ubuntu/project/TeamUp/'
#   code <<-EOH
#   sudo npm --no-bin-links install bcrypt
#   sudo npm --no-bin-links install body-parser
#   sudo npm --no-bin-links install connect-flash
#   sudo npm --no-bin-links install connect-mongo
#   sudo npm --no-bin-links install cookie-parser
#   sudo npm --no-bin-links install csurf
#   sudo npm --no-bin-links install express
#   sudo npm --no-bin-links install express-session
#   sudo npm --no-bin-links install express-validator
#   sudo npm --no-bin-links install helmet
#   sudo npm --no-bin-links install lodash
#   sudo npm --no-bin-links install mongoose
#   sudo npm --no-bin-links install nconf
#   sudo npm --no-bin-links install nodemailer
#   sudo npm --no-bin-links install passport
#   sudo npm --no-bin-links install passport-facebook
#   sudo npm --no-bin-links install passport-google-oauth
#   sudo npm --no-bin-links install passport-local
#   sudo npm --no-bin-links install passport-twitter
#   sudo npm --no-bin-links install pug
#   sudo npm --no-bin-links install socket.io
#   sudo npm --no-bin-links install winston
#   sudo npm --no-bin-links install xss-filters
#   bower install --allow-root
#   EOH
# end


# ######## MongoDB Config ########

# bash 'install_mongodb_and_start' do
#   code <<-EOH
#   mkdir -p /data/db
#   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
#   echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
#   sudo apt-get update
#   sudo apt-get install -y mongodb-org
#   sudo service mongod start
#   EOH
# end



####### Supervisor Config ########

# bash 'supervisord_config' do
#   code <<-EOH
#   sudo mkdir -p /etc/supervisor.d
#   sudo pip install supervisor
#   EOH
# end

# cookbook_file "supervisord.conf" do
#   path "/etc/supervisord.conf"
# end

# cookbook_file "server.conf" do
#   path "/etc/supervisor.d/server.conf"
# end

# bash 'supervisord_start' do
#   ignore_failure true
#   code <<-EOH
#   sudo supervisord
#   EOH
# end

# bash 'supervisord_kill_ifexists' do
#   code <<-EOH
#   sudo supervisorctl update
#   sudo supervisorctl restart all
#   EOH
# end



# bash 'run-server' do
#   cwd '/home/ubuntu/project/TeamUp/'
#   ignore_failure true
#   code <<-EOH
#   sudo pm2 stop all
#   sudo pm2 start ./bin/www -p 8080
#   EOH
# end