require 'spec_helper'

module OmniAuth::Strategies
  describe Twitter do
    it 'saves the original #initialize' do
      FakeWeb.should_not_receive(:register_uri)
      Twitter.allocate.send(:initialize_without_fakeweb, proc {}, 'KEY', 'SECRET')
    end

    it 'calls the original #initialize in the new one' do
      t = Twitter.allocate
      t.should_receive(:initialize_without_fakeweb)
      t.send(:initialize, proc {}, 'KEY', 'SECRET')
    end

    it 'registers some fake responses using FakeWeb' do
      Twitter.new(proc {}, 'KEY', 'SECRET')
      FakeResponse.for('POST', 'https://api.twitter.com/oauth/request_token').should be_registered
      FakeResponse.for('POST', 'https://api.twitter.com/oauth/access_token').should be_registered
      FakeResponse.for('GET',  'https://api.twitter.com/1/account/verify_credentials.json').should be_registered
    end
  end
end
