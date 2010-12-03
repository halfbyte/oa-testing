require File.join(File.dirname(__FILE__), '../../app')

require 'rspec'
require 'rack/test'
require 'webrat'
require 'fakeweb'

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(
  :post,
  'https://api.twitter.com/oauth/request_token',
  body: 'oauth_token=fake&oauth_token_secret=fake'
)

FakeWeb.register_uri(
 :post,
 'https://api.twitter.com/oauth/access_token',
 body: 'oauth_token=fake&oauth_token_secret=fake&user_id=218183011'
)

FakeWeb.register_uri(
  :get,
  'https://api.twitter.com/1/account/verify_credentials.json',
  body: File.read(File.join(File.dirname(__FILE__), '../fixtures/twitter_user.json'))
)

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
