require 'capistrano/ext/multistage'
require 'capistrano_colors'
require 'railsless-deploy'
require 'rubygems'
require 'yaml'

default_run_options[:pty] = true
set :application, "dacms"

set :scm, :git
set :repository,  "git@github.com:fun-dac/dacms.git"
set :branch, "master"

set :deploy_to, "/var/www"
set :deploy_via, :remote_cache
set :use_sudo, true

after "deploy", "change_permission"
after "deploy", "tagging"

desc "tmpディレクトリのパーミッションを設定"
task :change_permission, roles => :app do
  tmp_path = File.join(deploy_to, "/current/app/tmp")
  run <<-CMD
    chmod -R 777 #{tmp_path}
  CMD
end

desc "Gitにtagを打つ"
task :tagging, roles => :app do
  path = File.join(deploy_to, "/current/")
  name = Capistrano::CLI.ui.ask "バージョン名を入力してください(ex: v2.1): "
  run <<-CMD
    cd #{path} && git tag #{name}_#{release_name} #{revision} && git push --tags origin
  CMD
end
