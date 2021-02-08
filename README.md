# fbc-memo-app

メモの追加・編集・削除機能を持つシンプルなWebアプリです。

フィヨルドブートキャンプのSinatraプラクティスの提出物のためのリポジトリです。

## 使い方

1. `bundle install` を実行します  

       $ bundle install

2. `bundle exec rackup` でSinatraアプリケーションが起動します  

       $ bundle exec rackup

   `-p`オプションで任意のポート番号を指定できます

       $ bundle exec rackup -p 9999

   開発環境ではなく本番環境として起動する場合、`APP_ENV`環境変数に`production`をセットして起動します  

       $ APP_ENV=production bundle exec rackup

3. ブラウザで http://localhost:9292/ を開くとメモアプリが表示されます
