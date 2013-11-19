set :deploy_to, "/var/www/#{application}/production"
set :deploy_via, :remote_cache
set :deploy_env, 'production'
set :db_env, 'production'
set :use_sudo, false

role :app, '23.23.180.253'
role :db, '23.23.180.253', :primary => true