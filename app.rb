# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?

require_relative './memo'

memo_by_id = {}

get '/' do
  memos = memo_by_id.values.sort_by(&:updated_at).reverse
  erb :index, locals: { memos: memos }
end

post '/memos' do
  id, title, content = params.values_at('id', 'title', 'content')
  memo_by_id[id] = Memo.new(id: id, title: title, content: content)
  redirect to('/'), 303
end

get '/memos/new' do
  erb :'memos/edit', locals: { memo: Memo.new }
end

get '/memos/:memo_id' do |memo_id|
  memo = memo_by_id[memo_id] || halt(404)
  erb :'memos/view', locals: { memo: memo }
end

get '/memos/:memo_id/edit' do |memo_id|
  memo = memo_by_id[memo_id] || halt(404)
  erb :'memos/edit', locals: { memo: memo }
end
