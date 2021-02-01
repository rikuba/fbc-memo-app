# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?

require_relative './memo'

memo_by_id = {}

get '/' do
  erb :index
end

post '/memos' do
  id, title, content = params.values_at('id', 'title', 'content')
  memo_by_id[id] = Memo.new(id: id, title: title, content: content)
  'success'
end

get '/memos/new' do
  erb :'memos/edit', locals: { memo: Memo.new }
end
