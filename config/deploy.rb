set :application, 'myblog'
set :repo_url, 'git@github.com:kirs/myblog.git'

set :rbenv_ruby, '2.2.2'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :deploy_to, "/home/deploy/myblog"
set :bundle_flags, '--deployment'
