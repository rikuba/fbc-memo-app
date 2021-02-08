# frozen_string_literal: true

require 'securerandom'

class Memo
  attr_reader :id, :title, :content, :updated_at

  def update(title: @title, content: @content)
    validate_title(title)

    File.write(@path, "#{title}\n\n#{content}")

    @title = title
    @content = content
    @updated_at = File.mtime(@path)
  end

  def delete
    File.delete(@path)
  end

  private

  def initialize(path:, id:, title: nil, content: nil, updated_at: nil)
    validate_title(title)

    @path = path
    @id = id
    @title = title
    @content = content
    @updated_at = updated_at
  end

  def validate_title(title)
    raise 'タイトルに改行を含めることはできません' if /\n/.match?(title)
  end
end

class << Memo
  def all
    paths = Dir.glob(build_path('*'))
    paths.map do |path|
      id = File.basename(path, '.txt')
      self[id]
    end
  end

  def [](id)
    raise '不正なIDです' unless /\A[-0-9A-Za-z]+\Z/.match?(id)

    path = build_path(id)
    return nil unless File.exist?(path)

    title, content = File.read(path).split("\n\n", 2)
    updated_at = File.mtime(path)
    Memo.new(path: path, id: id, title: title, content: content, updated_at: updated_at)
  end

  def create
    id = generate_id
    path = build_path(id)
    Memo.new(path: path, id: id)
  end

  private

  def generate_id
    SecureRandom.uuid
  end

  def build_path(id)
    File.join('.', 'memos', "#{id}.txt")
  end
end
