# frozen_string_literal: true

require 'pg'
require 'time'
require 'yaml'

module MemoDB
  config = YAML.load_file('db_config.yml')
  @connection = PG.connect(config)
  at_exit { @connection.finish }
  @connection.exec(<<~SQL)
    CREATE TABLE IF NOT EXISTS memos (
      id UUID PRIMARY KEY,
      title VARCHAR(128) NOT NULL,
      content VARCHAR(2048) NOT NULL,
      updated_at TIMESTAMP WITH TIME ZONE NOT NULL
    )
  SQL

  {
    create_memo: 'INSERT INTO memos (id, title, content, updated_at) VALUES ($1, $2, $3, $4)',
    read_memo: 'SELECT id, title, content, updated_at FROM memos WHERE id = $1',
    read_all_memos: 'SELECT id, title, content, updated_at FROM memos',
    update_memo: 'UPDATE memos SET title = $1, content = $2, updated_at = $3 WHERE id = $4',
    delete_memo: 'DELETE FROM memos WHERE id = $1'
  }.each do |name, sql|
    @connection.prepare(name.to_s, sql)
  end
end

class << MemoDB
  def create(memo)
    @connection.exec_prepared('create_memo', [memo.id, memo.title, memo.content, memo.updated_at])
  end

  def read(id)
    result = @connection.exec_prepared('read_memo', [id])
    result.map { |record| record_to_hash(record) }[0]
  end

  def read_all
    result = @connection.exec_prepared('read_all_memos')
    result.map { |record| record_to_hash(record) }
  end

  def update(memo)
    @connection.exec_prepared('update_memo', [memo.title, memo.content, memo.updated_at, memo.id])
  end

  def delete(id)
    @connection.exec_prepared('delete_memo', [id])
  end

  private

  def record_to_hash(record)
    hash = record.map { |k, v| [k.to_sym, v] }.to_h
    hash[:updated_at] = Time.parse(hash[:updated_at])
    hash
  end
end
