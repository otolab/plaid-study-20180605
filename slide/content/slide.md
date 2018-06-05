name: Naoto Kato
layout: true

---

class: center, middle, inverse

# イマドキのDocker力を身につけるHands-on

by otolab


---

class: center, middle, inverse

# 準備

cd ./step0


---


## 前準備


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


---

name: agenda
class: inverse

# Agenda


1. すこし知る
2. 組み立てて動かす
3. 基本を理解する
4. 環境を作る
5. nginxで遊ぶ
6. KARTEのDocker開発環境(v2)
7. (もう少し理解する)


---

class: section-1
template: agenda

---

class: center, middle, inverse

# すこし知る


---


## Docker

* linuxのLXCを利用したコンテナ実行環境
  - https://plaid.esa.io/posts/1394
  - ikemonnによるまとめ


---


## Docker for Mac

* Docker for xxシリーズ
* DockerをLinux以外で使うための仕組み一式
  - VMの中でLinuxが動いており、それと連携するMacのツール群


---

class: section-2
template: agenda

---

class: center, middle, inverse

# 組み立てて動かす

`cd ./step1`

動かしてみる


---


## Docker Compose

* `docker-compose.yml`
* `docker-compose up -d`
* `docker ps`
* kitematicでみてみる


---


## 中に入ってみる

* `docker-compose exec container1 /bin/bash`
  - `echo 'ok' > testfile`
  - `cat testfile`

そのほかいろいろやってみてください


---


## 止めてみる

* `docker-compose down`
* `docker ps`
* `docker-compose exec container1 /bin/bash`
  - 起動していないので動かせない


---


## container内での編集はcleanされる

* `docker-compose up -d`
* `docker-compose exec container1 /bin/bash`
  - `cat testfile`
  - ファイルがなくなってる


---


## mongoを足す

* `docker-compose down`
* `docker-compose.yml` のコメントを外す
* `docker-compose up -d`
  - `docker-compose logs mongo`
* `docker-compose exec container1 /bin/bash`
  - `apt-get update && apt-get install mongodb-clients`
  - `mongo mongo:27017`


---


## container1からmongoを叩くのをhostから行う

* `docker-compose exec container1 mongo mongo:27017`
  - `/bin/bash`の代わりにmongoのclientを起動している

sshでリモートのコマンドを叩くのと同じ


---


## 止めたらどうなる？

面倒だからやらないけど、mongodb-clientsもmongodbの中身も消える

消えるというより、きれいになる

（まだとめないでおいてください）


---


## TRY

* `mongo_insert.sh`はサンプルデータを投入するコードです
* mongoのバージョンアップをしてみましょう


---

class: section-3
template: agenda

---

class: center, middle, inverse

# 基本を理解する

Image, Container, Volume, Portを理解する

やるきのない絵の[スライド](./plaid_study_20180605.pdf)を見つつ。


---


## Image

* `docker images`


---


## Container

* `docker ps`
* `docker ps -a`
* kitematicで見てみる


---


## Volume

* `docker volume ls`


---


## Port

* kitematicでmongoのコンテナを見てみる


---

class: section-4
template: agenda

---

class: center, middle, inverse

# 環境を作る

`cd ./step2`

Docker Imageを作ってみる


---


## Dockerfile

* `Dockerfile`


---


## 作ってみる

* `docker-compose build`
* `docker-compose up -d`


---


## ログを見る

* `docker-compose logs -f`
* kitematicで開いておく


---


## 入ってみる

* `docker-compose exec container2 /bin/bash`
* `vi message.txt`
* `rm message.txt`
  - 止まる（コンテナはあるけどルートプロセスがいない状態）


---


## TRY

* docker-compose.ymlから環境変数上書きしてみよう！
* mongodb-clientsとjqをDockerfileで入れて、mongoコンテナとつないでみよう！


---

class: section-5
template: agenda

---

class: center, middle, inverse

# nginxで遊ぶ


`cd ./step3`

nginxで遊び、データの寿命を理解する


---


## nginxをカスタマイズする

* Dockerfileを読んで見る
* `docker-compose build`
* `docker-compose up -d`

https://hub.docker.com/_/nginx/


---


## 一時的な編集

* `docker-compose exec container3 /bin/bash`
  - `vi index.html`
* `docker-compose down` すると消える


---


## Volume

* `docker-compose exec container3 /bin/bash`
  - `vi volume/index.html`
* `docker-compose down` しても消えない
* `docker-compose down -v` すると消える


---


## Host-Volume

* ホスト側で編集する `./step3/host-volume/index.html`

内部的にはosxfsというネットワークファイルシステム的なものが動いている


---

class: section-6
template: agenda

---

class: center, middle, inverse

# KARTEのDocker開発環境(v2)

`cd ./karte-io`

そろそろ読めるようになるはず


---


## docker-compose.yml

* adminがメインのコンテナ
* host volumeでホスト上のファイルを見ている
* 他にはwatchとかbigtable(thrift)とかmongoとか


---


## Dockerfile-node

* karte-ioサーバを動かすための環境Image
* [plaid/karte-io](https://cloud.docker.com/swarm/plaid/repository/docker/plaid/karte-io/general)
  - ビルド済みのものはDocker Hubに置かれている
  - ログインしないと見えない


---


## scripts/docker/

* `docker-compose exec container1 ./scripts/docker/debug_admin.sh`
  - 今後変わるかも
  - `karte run debug`とかになるイメージ


---


## TRY

* `karte-io`を動かしてみよう
  - [Dockerによるkarte実行環境構築v2](https://plaid.esa.io/posts/1895)
* `npm run container-upgrade`が何をしているのか見てみよう


---

class: section-7
template: agenda

---

class: center, middle, inverse

# もう少し理解する

* オーケストレーションとはなにか
* Kubernates(k8s)

...to be continued.


---


class: center, middle, inverse

# おつかれさまでした

