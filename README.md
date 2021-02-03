# fbc-memo-app

メモの追加・編集・削除機能を持つシンプルなWebアプリです。

フィヨルドブートキャンプのSinatraプラクティスの提出物のためのリポジトリです。

## 使い方

1. `bundle install` を実行します  

       $ bundle install

2. `bundle exec ruby app.rb` でSinatraアプリケーションが起動します  

       $ bundle exec ruby app.rb

   `-p`オプションで任意のポート番号を指定できます

       $ bundle exec ruby app.rb -p 9292

   開発環境ではなく本番環境として起動する場合、`APP_ENV`環境変数に`production`をセットして起動します  

       $ APP_ENV=production bundle exec ruby app.rb

3. ブラウザで http://localhost:4567/ を開くとメモアプリが表示されます
