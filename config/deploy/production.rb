set :deploy_to, "/var/www/#{application}/production"
set :deploy_via, :remote_cache
set :deploy_env, 'production'
set :db_env, 'production'
set :use_sudo, false

role :app, '54.234.237.46'
role :db, '54.234.237.46', :primary => true