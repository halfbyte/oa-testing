require 'omniauth/strategies/facebook'
require 'fakeweb'

class OmniAuth::Strategies::Facebook
  alias_method :initialize_without_fakeweb, :initialize
  private :initialize_without_fakeweb

  def initialize(*args)
    initialize_without_fakeweb(*args)

    FakeWeb.register_uri(
     :post,
     'https://graph.facebook.com/oauth/access_token',
     body: 'oauth_token=fake&oauth_token_secret=fake&user_id=100001732014698'
    )

    FakeWeb.register_uri(
      :get,
      'https://graph.facebook.com/me?access_token=',
      body: File.read(File.join(File.dirname(__FILE__), '../fixtures/facebook_user.json'))
    )
  end
end
