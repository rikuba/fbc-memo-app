# frozen_string_literal: true

require 'securerandom'

class Memo
  attr_reader :id
  attr_accessor :title, :content, :updated_at

  def initialize(id: SecureRandom.uuid, title: '', content: '', updated_at: Time.now)
    @id = id
    @title = title
    @content = content
    @updated_at = updated_at
  end
end
