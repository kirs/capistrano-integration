#!/usr/bin/env bash

apt-get update
apt-get install -y git-core build-essential tklib zlib1g-dev libssl-dev libreadline-gplv2-dev libxml2 libxml2-dev libxslt1-dev libsqlite3-dev
adduser --disabled-password --gecos "" deploy
echo "deploy:deploy" | chpasswd

su deploy
cd
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bash_profile
rbenv install 2.2.2
rbenv global 2.2.2
gem i bundler --no-ri --no-rdoc

mkdir -p /home/deploy/myblog/shared/config
echo -e "production:\n  adapter: sqlite3\n  pool: 5\n  timeout: 5000\n  database: db/production.sqlite3" >> /home/deploy/myblog/shared/config/database.yml
