# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qna'
set :repo_url, 'git@github.com:dzivalli/qna.git'
set :rails_env, :production

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'


# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', '.env', 'config/private_pub.yml', 'puma.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

# private pub tasks
set :private_pub_pid, -> { "#{current_path}/tmp/pids/private_pub.pid" }

namespace :private_pub do
  desc "Start private_pub server"
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec thin -C config/private_pub/thin_#{fetch(:stage)}.yml -d -P #{fetch(:private_pub_pid)} start"
        end
      end
    end
  end

  desc "Stop private_pub server"
  task :stop do
    on roles(:app) do
      within release_path do
        execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
      end
    end
  end

  desc "Restart private_pub server"
  task :restart do
    on roles(:app) do
      invoke 'private_pub:stop'
      invoke 'private_pub:start'
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
