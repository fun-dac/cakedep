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
after "deploy", "adjust_envfiles"
after "deploy", "tagging"

desc "tmpディレクトリのパーミッションを設定"
task :change_permission, roles => :app do
  tmp_path = File.join(deploy_to, "/current/app/tmp")
  run <<-CMD
    chmod -R 777 #{tmp_path}
  CMD
end

desc "環境依存ファイルをproduction環境に合わせる"
task :adjust_envfiles, roles => :app do
  files = YAML::load open(File.dirname(__FILE__)+'/envfiles.yaml').read
  env = ".production"

  files.each do |f|
    target = File.join(deploy_to, "/current", f)
    run <<-CMD
      cp #{target + env} #{target}
    CMD
  end
end

desc "Gitにtagを打つ"
task :tagging, roles => :app do
  path = File.join(deploy_to, "/current/")
  name = Capistrano::CLI.ui.ask "バージョン名を入力してください(ex: v2.1): "
  run <<-CMD
    cd #{path} && git tag #{name}_#{release_name} #{revision} && git push --tags origin
  CMD
end
