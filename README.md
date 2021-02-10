# fbc-memo-app

メモの追加・編集・削除機能を持つシンプルなWebアプリです。

フィヨルドブートキャンプのSinatraプラクティスの提出物のためのリポジトリです。

## 前提条件

このWebアプリを起動するには事前にPostgreSQLをインストールしておく必要があります。

- [postgresql — Homebrew Formulae](https://formulae.brew.sh/formula/postgresql)
- [PostgreSQL: Downloads](https://www.postgresql.org/download/)

## 使い方

1. PostgreSQLに`fbc_memo_app`という名前のデータベースを作成します  
   （異なる名前で作成する場合、`db_config.yml`ファイル内の`dbname`の値を編集します）  

       $ createdb fbc_memo_app

1. `bundle install` を実行します  

       $ bundle install

1. `bundle exec rackup` でSinatraアプリケーションが起動します  

       $ bundle exec rackup

   `-p`オプションで任意のポート番号を指定できます

       $ bundle exec rackup -p 9999

   開発環境ではなく本番環境として起動する場合、`APP_ENV`環境変数に`production`をセットして起動します  

       $ APP_ENV=production bundle exec rackup

1. ブラウザで http://localhost:9292/ を開くとメモアプリが表示されます
