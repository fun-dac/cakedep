#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "fileutils"

#./setRebase CakePHPルートディレクトリ 設定したいRewriteBase
#として実行することで.htaccessを作成!

def htcreate(path, doc)
  ht=path+"/.htaccess"
  FileUtils.mv(ht, ht+"-org") if File.exists?(ht)
  File.open(ht, "w") do |f|
    f.puts doc
  end
  File.chmod(0604, ht)
end

if ARGV.size < 2
  puts "./setReBase CAKEROOT CakeRoot_RewriteBase"
  exit(0)
end

root = ARGV[0]
root = root[0..root.length-2] if root[root.length-1] == "/"
app = ARGV[0]+"/app"
webroot = app+"/webroot"

if !(File.exists?(root) && File.exists?(app) && File.exists?(webroot))
  puts "directory does not exist"
  exit(0)
end

rebase = ARGV[1]
rebase = "" if ARGV[1] == "/"
rebase = rebase[0..rebase.length-2] if rebase[rebase.length-1] == "/"
rebase = "/"+rebase if rebase[0] != "/"
rootDoc = <<-EOF
<IfModule mod_rewrite.c>
  RewriteEngine on
  RewriteBase #{rebase}
  RewriteRule    ^$ app/webroot/    [L]
  RewriteRule    (.*) app/webroot/$1 [L]
</IfModule>
EOF

appDoc = <<-EOF
<IfModule mod_rewrite.c>
  RewriteEngine on
  RewriteBase #{rebase+"/app"}
  RewriteRule    ^$    webroot/    [L]
  RewriteRule    (.*) webroot/$1    [L]
</IfModule>
EOF

webrootDoc = <<-EOF
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase #{rebase+"/app/webroot"}
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ index.php?url=$1 [QSA,L]
</IfModule>
EOF

htcreate(root, rootDoc)
htcreate(app, appDoc)
htcreate(webroot, webrootDoc)
