# frozen_string_literal: true

class Memo
  attr_reader :id, :title, :content, :updated_at

  def initialize(id, title, content, updated_at)
    @id = id
    @title = title
    @content = content
    @updated_at = updated_at
  end
end
