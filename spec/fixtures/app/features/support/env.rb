require File.join(File.dirname(__FILE__), '../../app')

require 'rspec'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

module AppWorld
  include Rack::Test::Methods
  include Webrat::Methods

  def app
    Sinatra::Application
  end
end

World(AppWorld)
