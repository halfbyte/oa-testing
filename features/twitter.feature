Feature: Twitter

  Scenario:
    Given I have a Sinatra app with Cucumber and OmniAuth
    When I add a "User signs up" feature with:
      """
      Scenario: The user chooses to authorize through Twitter
        Given I am on the homepage
        When I follow "Sign up using Twitter"
        And I authorize the app to read my Twitter info
        Then I should see an OmniAuth hash of my Twitter info
      """
    And I add the "Twitter" strategy to the middleware stack
    And I add a link to "/auth/twitter" with the text "Sign up using Twitter" to the homepage
    And I add the following step definition to the user steps:
      """
      When /^I authorize the app to read my Twitter info$/ do
        visit '/auth/twitter/callback'
      end
      """
    And I add the following to my Sinatra app:
      """
      get '/auth/twitter/callback' do
        request.env['omniauth.auth'].to_yaml
      end
      """
    And I add the following step definition to the user steps:
      """
      Then /^I should see an OmniAuth hash of my Twitter info$/ do
        auth_hash = YAML.load(response.body)
        auth_hash['provider'].should == 'twitter'
        auth_hash['user_info']['name'].should == 'James Garcia'
      end
      """
    When I bundle the oa-testing gem and require it in "features/support/env.rb"
    Then the features should pass
