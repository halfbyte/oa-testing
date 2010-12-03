Given /^I am on the homepage$/ do
  visit '/'
end

When /^I follow "([^"]*)"$/ do |selector|
  click_link selector
end
