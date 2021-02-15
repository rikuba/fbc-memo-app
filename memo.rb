# frozen_string_literal: true

require 'securerandom'

require_relative './memo_db'

class Memo
  attr_reader :id, :title, :content, :updated_at

  def update(title: @title, content: @content)
    @title = title
    @content = content
    @updated_at = Time.now

    MemoDB.update(self)
  end

  def delete
    MemoDB.delete(@id)
  end

  private

  def initialize(id:, title:, content:, updated_at:)
    @id = id
    @title = title
    @content = content
    @updated_at = updated_at
  end
end

class << Memo
  def all
    MemoDB.read_all.map { |hash| new(**hash) }
  end

  def [](id)
    hash = MemoDB.read(id)
    hash && new(**hash)
  end

  def create(title:, content:)
    id = SecureRandom.uuid
    memo = new(id: id, title: title, content: content, updated_at: Time.now)
    MemoDB.create(memo)
    memo
  end
end
