#!/bin/bash

## Githubのpush時に実行されるデプロイ用スクリプト
## Sinatraアプリ(Githook)から呼び出される。

if [ $# != 2 ]; then
    echo "usage: $0 CakeRoot_path RewiteBase_name" 1>&2
    exit 0
fi

cd $1 #CakePHPルートへ移動
cp app/config/path.php.development app/config/path.php

chmod 777 app/tmp/logs
chmod 777 app/tmp/cache/models
chmod 777 app/tmp/cache/persistent
chmod 777 app/tmp/cache/views

ruby /Users/exit/MyCode/cakedep/set_rebase.rb $1 $2 #RewiteBaseの書き換え
