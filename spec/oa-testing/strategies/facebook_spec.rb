require 'spec_helper'

module OmniAuth::Strategies
  describe Facebook do
    it 'saves the original #initialize' do
      FakeWeb.should_not_receive(:register_uri)
      Facebook.allocate.send(:initialize_without_fakeweb, proc {}, 'ID', 'SECRET')
    end

    it 'calls the original #initialize in the new one' do
      t = Facebook.allocate
      t.should_receive(:initialize_without_fakeweb)
      t.send(:initialize, proc {}, 'ID', 'SECRET')
    end

    it 'registers some fake responses using FakeWeb' do
      Facebook.new(proc {}, 'ID', 'SECRET')
      FakeResponse.for('POST', 'https://graph.facebook.com/oauth/access_token').should be_registered
      FakeResponse.for('GET',  'https://graph.facebook.com/me?access_token=').should be_registered
    end
  end
end
