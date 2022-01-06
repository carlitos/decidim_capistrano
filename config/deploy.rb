# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "decidim_project"
set :repo_url, "your_repository.git"
set :rails_env, 'production'
# set :deploy_user, 'deploy'
set :deploy_to, "/var/www/#{fetch :application}"

# Defaults to :db role
set :migration_role, :db

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }
set :conditionally_migrate, false
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5
set :branch, 'main'
set :rbenv_type, :user
set :rbenv_ruby, '2.7.5'


append :linked_files, 'config/database.yml'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/packs", ".bundle", "node_modules"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

