# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

require_relative './memo'

class MemoStore
  def self.generate_id
    SecureRandom.uuid
  end

  def initialize(dir)
    FileUtils.mkdir_p(dir)
    @dir = dir
  end

  def [](id)
    path = build_path(id)
    return nil unless File.exist?(path)

    title, content = File.read(path).split("\n\n", 2)
    updated_at = File.mtime(path)
    Memo.new(id, title, content, updated_at)
  end

  def []=(id, title:, content:)
    path = build_path(id)
    File.write(path, "#{title}\n\n#{content}")
  end

  def all
    paths = Dir.glob(build_path('*'))
    paths.map do |path|
      id = File.basename(path, '.txt')
      self[id]
    end
  end

  private

  def build_path(id)
    File.join(@dir, "#{id}.txt")
  end
end
