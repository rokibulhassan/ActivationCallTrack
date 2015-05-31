# config valid only for current version of Capistrano
lock '3.4.0'
set :rails_env, 'production'

set :user, 'dev'
set :application, 'activation_call_track'
set :repo_url, 'https://rokibulhassan@github.com/rokibulhassan/ActivationCallTrack.git'
set :branch, :master

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :default_env, {path: "/opt/ruby/bin:$PATH"}
set :keep_releases, 3

set :default_shell, '/bin/bash -l'


set :rbenv_ruby, '2.1.0'
set :bundle_bins, %w("bundle exec")
set :rvm_map_bins, %w{gem rake ruby bundle}
set :bundle_roles, :app
set :migration_role, :db

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/pids/puma.state"
set :puma_pid, "#{shared_path}/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/sockets/puma.sock" #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [8, 32]
set :puma_workers, 3
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, true
set :puma_prune_bundler, false

# set :sidekiq_pid, "#{shared_path}/pids/sidekiq.pid"
# set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }


SSHKit.config.command_map[:rake] = "bundle exec rake"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/sockets -p"
      execute "mkdir #{shared_path}/pids -p"
    end
  end

  before :start, :make_dirs
end

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
