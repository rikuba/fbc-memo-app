# frozen_string_literal: true

require 'rack/protection'
require_relative './app'
use Rack::Protection::ContentSecurityPolicy, { default_src: "'self'" }
run Sinatra::Application
