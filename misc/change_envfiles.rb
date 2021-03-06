#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "fileutils"
require "yaml"

# 環境依存のファイルをファイル名で分けてあるので
# .php.development もしくは .php.productionとしてあるファイル群を
# .phpに戻す

#環境依存ファイル
envfiles = YAML::load open(File.dirname(__FILE__)+'/envfiles.yaml').read

if ARGV.size < 2
  puts "ruby envFile.rb MODE(-dev or -pro) CAKEROOT"
  exit(0)
end

if ARGV[0] == "-dev"
  mode = ".development"
elsif ARGV[0] == "-pro"
  mode = ".production"
else
  puts "mode error"
  exit(0)
end

root = ARGV[1]
root = root[0..root.length-2] if root[root.length-1] == "/"

envfiles.each do |f|
  target = root + f
  next unless File.exists?(target + mode)

  puts "target: " + target + mode
  FileUtils.copy(target + mode, target)
end
