#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "fileutils"

#./cleanTmp cakerootのフルパス
#でcakeroot/app/tmp/cacheとlogs内を掃除

if ARGV.size < 1
  puts "./cleanTmp CAKEROOT"
  exit(0)
end

root = ARGV[0]
root = root[0..root.length-2] if root[root.length-1] == "/"
cache = root+"/app/tmp/cache"
logs = root+"/app/tmp/logs"

FileUtils.rm_r(logs) if File.exists?(logs)
FileUtils.mkdir_p(logs)

FileUtils.rm_r(cache) if File.exists?(cache)
FileUtils.mkdir_p(cache+"/models")
FileUtils.mkdir_p(cache+"/persistent")
FileUtils.mkdir_p(cache+"/views")

FileUtils.chmod_R(0707, cache)
FileUtils.chmod_R(0707, logs)


