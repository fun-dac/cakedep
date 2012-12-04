#!/bin/bash

## Githubのpush時に実行されるデプロイ用スクリプト
## Sinatraアプリ(Githook)から呼び出される。

if [ $# != 2 ]; then
    echo "usage: $0 CakeRoot_path RewiteBase_name" 1>&2
    exit 0
fi

cd $1 #CakePHPルートへ移動

#環境依存ファイルの変更
cp app/config/path.php.development app/config/path.php

chmod -R 777 app/tmp/ #log,cacheのパーミッション書き換え
ruby set_rebase.rb $1 $2 #RewiteBaseの書き換え
