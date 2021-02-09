# frozen_string_literal: true

require 'pg'
require 'time'
require 'yaml'

module MemoDB
  config = YAML.load_file('db_config.yml')
  @connection = PG.connect(config)
  @connection.exec(<<~SQL)
    CREATE TABLE IF NOT EXISTS memos (
      id UUID PRIMARY KEY,
      title VARCHAR(128) NOT NULL,
      content VARCHAR(2048) NOT NULL,
      updated_at TIMESTAMP WITH TIME ZONE NOT NULL
    )
  SQL
end

class << MemoDB
  def create(memo)
    @connection.exec_params(
      'INSERT INTO memos (id, title, content, updated_at) VALUES ($1, $2, $3, $4)',
      [memo.id, memo.title, memo.content, memo.updated_at]
    )
  end

  def read(id)
    result = @connection.exec_params(
      'SELECT id, title, content, updated_at FROM memos WHERE id = $1',
      [id]
    )
    result.map { |record| record_to_hash(record) }[0]
  end

  def read_all
    result = @connection.exec('SELECT id, title, content, updated_at FROM memos')
    result.map { |record| record_to_hash(record) }
  end

  def update(memo)
    @connection.exec_params(
      'UPDATE memos SET title = $1, content = $2, updated_at = $3 WHERE id = $4',
      [memo.title, memo.content, memo.updated_at, memo.id]
    )
  end

  def delete(id)
    @connection.exec_params('DELETE FROM memos WHERE id = $1', [id])
  end

  private

  def record_to_hash(record)
    hash = record.map { |k, v| [k.to_sym, v] }.to_h
    hash[:updated_at] = Time.parse(hash[:updated_at])
    hash
  end
end
