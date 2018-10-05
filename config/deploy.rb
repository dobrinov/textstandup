lock "~> 3.11.0"

set :application, 'textstandup'
set :repo_url, 'git@github.com:dobrinov/textstandup.git'

# Deployment
set :deploy_user, 'deploy'
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"
set :keep_releases, 3

# Rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'
set :rbenv_custom_path, "/home/#{fetch(:deploy_user)}/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}
set :rbenv_roles, :all

# Puma
set :puma_threads, [0, 16]
set :puma_workers, 2
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# Linked resources
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}
set :linked_files, %w{config/database.yml .env}

set :format, :airbrussh
set :log_level, :debug
set :pty, false
set :use_sudo, false
set :stage, :production

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  before :updated, 'yarn:install'
end

namespace :yarn do
  desc 'Install yarn dependencies'
  task :install do
    on roles(:app) do
      within release_path do
        execute :yarn, :install
      end
    end
  end
end
