#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "fileutils"

#プロダクション環境にデプロイする
#gitでリリース版ソースをマージしてある前提

if ARGV.size != 1
  puts "Usage: #{$0} CAKE_ROOT"
  exit 0
end
cakeroot = ARGV[0]

#tmp以下の権限変更
FileUtils.chmod_R(0707, File.join(cakeroot, "/app/tmp/cache"))
FileUtils.chmod_R(0707, File.join(cakeroot, "/app/tmp/logs"))

#環境依存ファイルの置き換え(change_envfiles.rb流用)
mode = ".production"
envfiles = ["/app/config/core.php",
            "/app/config/database.php",
            "/app/config/path.php",
            "/app/webroot/robots.txt",
            "/app/webroot/catalogCheck.php",
            "/app/webroot/catalogConfirm.php",
            "/app/webroot/catalogSave.php"]

envfiles.each do |f|
  target = File.join(cakeroot, f)
  next unless File.exists?(target + mode)

  puts "target: " + target + mode
  FileUtils.copy(target + mode, target)
end
