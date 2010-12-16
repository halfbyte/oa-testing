require 'omniauth/strategies/twitter'
require 'fakeweb'

class OmniAuth::Strategies::Twitter
  alias_method :initialize_without_fakeweb, :initialize
  private :initialize_without_fakeweb

  def initialize(*args)
    initialize_without_fakeweb(*args)

    FakeWeb.register_uri(
      :post,
      'https://api.twitter.com/oauth/request_token',
      :body => 'oauth_token=fake&oauth_token_secret=fake'
    )

    FakeWeb.register_uri(
     :post,
     'https://api.twitter.com/oauth/access_token',
     :body => 'oauth_token=fake&oauth_token_secret=fake&user_id=218183011'
    )

    FakeWeb.register_uri(
      :get,
      'https://api.twitter.com/1/account/verify_credentials.json',
      :body => File.read(File.join(File.dirname(__FILE__), '../fixtures/twitter_user.json'))
    )
  end
end
