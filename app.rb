# frozen_string_literal: true

require 'erubi'
require 'sinatra'
require 'sinatra/reloader' if development?

require_relative './memo_store'

set :erb, escape: true

memo_store = MemoStore.new('./memos')

get '/' do
  memos = memo_store.all.sort_by(&:updated_at).reverse
  erb :index, locals: { memos: memos }
end

post '/memos' do
  id, title, content = params.values_at('id', 'title', 'content')
  memo_store[id] = { title: title, content: content }
  redirect to('/'), 303
end

get '/memos/new' do
  erb :'memos/new', locals: { id: MemoStore.generate_id }
end

get '/memos/:memo_id' do |memo_id|
  memo = memo_store[memo_id] || halt(404)
  erb :'memos/view', locals: { memo: memo }
end

get '/memos/:memo_id/edit' do |memo_id|
  memo = memo_store[memo_id] || halt(404)
  erb :'memos/edit', locals: { memo: memo }
end
