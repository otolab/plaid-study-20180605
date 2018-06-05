
# イマドキのDockerを理解するメソッド

by otolab


準備
=============

cd ./step0

前準備
------------

* Docker for Mac, Kitematicのインストール
  - 参考: https://qiita.com/seijimomoto/items/357ac7aa84f98b96021f
  - https://store.docker.com/editions/community/docker-ce-desktop-mac
  - すでに入っているひとは不要
  - 「Preferences...＞Advanced」でCPUsを6、Memoryを10.0GiBにしてApply
  - Docker for Macのメニュー「Kitematic」をクリックして指示通りに進む
* Docker cloudへのログイン
  - https://cloud.docker.com にアクセス
  - Lastpassでhub.docker.comのパスワードをコピー（ユーザ名はplaid）
  - 「Sign in / Create Docker ID」からダイアログを開きログイン
  - メニューからRepositoriesなどが見えるようになれば成功
* karte-ioのイメージ取得、準備
  - karte-ioリポジトリを新規clone（いつも使っているところでも良い）
  - `npm run container-upgrade` してしばし待つ
* Hands-onリポジトリのclone
  - https://github.com/otolab/plaid-study-20180605



すこし理解する
===============

Docker
------------

* linuxのLXCを利用したコンテナ実行環境
  - https://plaid.esa.io/posts/1394
  - ikemonnによるまとめ


Docker for Mac
------------

* Docker for xxシリーズ
* DockerをLinux以外で使うための仕組み一式
  - VMの中でLinuxが動いており、それと連携するMacのツール群



環境を組み立てる
=============

cd ./step1

Docker Compose
---------------

* `docker-compose.yml`
* `docker-compose up -d`
* kitematicでみてみる


中に入ってみる
------------

* `docker-compose exec container1 /bin/bash`
* `echo 'ok' > testfile`
* `cat testfile`

そのほかいろいろやってみてください


止めてみる
-----------

* `docker-compose down`
* `docker ps`
* `docker-compose exec container1 /bin/bash`
  - 起動していないので動かせない


container内での編集はcleanされる
-------------------

* `docker-compose up -d`
* `docker-compose exec container1 /bin/bash`
* `cat testfile`
  - ファイルがなくなってる


mongoを足す
-------------

* `docker-compose down`
* `docker-compose.yml` のコメントを外す
* `docker-compose up -d`
  - `docker-compose logs mongo`
* `docker-compose exec container1 /bin/bash`
* `apt-get update && apt-get install mongodb-clients`
* `mongo mongo:27017`


container1からmongoを叩くのをhostから行う
--------------------

* `docker-compose exec container1 mongo mongo:27017`
  - `/bin/bash`の代わりにmongoのclientを起動している
* `mongo_insert.sh`はサンプルデータを投入するコード

sshでリモートのコマンドを叩くのと同じ


止めたらどうなる？
-----------

面倒だからやらないけど、mongodb-clientsもmongodbの中身も消える

消えるというより、きれいになる

（まだとめないでおいてください）


基本を理解する
============

Image, Container, Volume, Portを理解する

Image
--------------

* `docker images`


Container
------------------

* `docker ps`
* `docker ps -a`
* kitematicで見てみる


Volume
-----------------

* `docker volume ls`


Port
--------------

* kitematicでmongoのコンテナを見てみる


環境を作る
==============

cd ./step2

Dockerfile
------------

* `Dockerfile`

作ってみる
--------------

* `docker-compose build`
* `docker-compose up -d`


ログを見る
-------------

* `docker-compose logs -f`
* kitematicで開いておく

入ってみる
-------------

* `docker-compose exec test /bin/bash`
* `vi message.txt`
* `rm message.txt`
  - 止まる（コンテナはあるけどルートプロセスがいない状態）


TRY
-----------------

* docker-compose.ymlから環境変数上書きしてみよう！
* mongodb-clientsとjqをDockerfileで入れて、mongoコンテナとつないでみよう！


ContainerとHost
================

cd ./step3

nginxをカスタマイズする
------------------

* https://hub.docker.com/_/nginx/
* Dockerfileを読んで見る
* `docker-compose build`
* `docker-compose up -d`

一時的な編集
----------

* `docker-compose exec container3 /bin/bash`
* `vi index.html`
* `docker-compose down` すると消える

Volume
-------------

* `vi volume/index.html`
* `docker-compose down` しても消えない
* `docker-compose down -v` すると消える


Host-Volume
------------------

* ホスト側で編集する `./step3/host-volume/index.html`

内部的にはosxfsというネットワークファイルシステム的なものが動いている


KARTEのDocker開発環境(v3)
===============

cd ./karte-io

docker-compose.yml
---------------

* adminがメインのコンテナ
* host volumeでホスト上のファイルを見ている
* 他にはwatchとかbigtable(thrift)とかmongoとか


Dockerfile-node
---------------

* karte-ioサーバを動かすための環境Image
* [plaid/karte-io](https://cloud.docker.com/swarm/plaid/repository/docker/plaid/karte-io/general)
  - ビルド済みのものはDocker Hubに置かれている
  - ログインしないと見えない

scripts/docker/
----------------

* `docker-compose exec container1 ./scripts/docker/debug_admin.sh`
  - 今後変わるかも
  - `karte run debug`とかになるイメージ


TRY
-------------

* `karte-io`を動かしてみよう
  - [Dockerによるkarte実行環境構築v2](https://plaid.esa.io/posts/1895)
* `npm run container-upgrade`が何をしているのか見てみよう


もう少し理解する
=================

* オーケストレーション

...to be continued.




















