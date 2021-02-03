# frozen_string_literal: true

require 'erubi'
require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?

require_relative './memo_store'

set :erb, escape: true

memo_store = MemoStore.new('./memos')

helpers do
  def format_as_date(time)
    wday = '日月火水木金土'[time.wday]
    time.strftime("%Y年%-m月%-d日(#{wday})")
  end

  def format_as_time(time)
    time.strftime('%-H時%-M分%-S秒')
  end
end

not_found do
  erb :'404'
end

get '/' do
  memos = memo_store.all.sort_by(&:updated_at).reverse
  erb :index, locals: { memos: memos }
end

post '/memos' do
  id = MemoStore.generate_id
  title, content = params.values_at('title', 'content')
  break redirect to('/'), 303 if (title.nil? || title.empty?) && (content.nil? || content.empty?)

  title = title.tr("\n", ' ')
  memo_store.save(Memo.new(id, title, content))
  redirect to("/memos/#{id}"), 303
end

get '/memos/new' do
  erb :'memos/new'
end

get '/memos/:memo_id' do |memo_id|
  memo = memo_store[memo_id] || halt(404)
  erb :'memos/view', locals: { memo: memo }
end

patch '/memos/:memo_id' do |memo_id|
  memo = memo_store[memo_id] || halt(404)
  title, content = params.values_at('title', 'content')
  memo.title = title unless title.nil?
  memo.content = content unless content.nil?
  memo_store.save(memo)
  redirect to("/memos/#{memo_id}"), 303
end

delete '/memos/:memo_id' do |memo_id|
  memo_store[memo_id] || halt(404)
  memo_store.delete(memo_id)
  redirect to('/'), 303
end

get '/memos/:memo_id/edit' do |memo_id|
  memo = memo_store[memo_id] || halt(404)
  erb :'memos/edit', locals: { memo: memo }
end
