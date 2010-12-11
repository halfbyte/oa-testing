Given /^I have a Sinatra app with Cucumber and OmniAuth$/ do
  FileUtils.rm_rf(App::ROOT)
  FileUtils.cp_r(File.join(ROOT, 'spec/fixtures/app'), App::ROOT)
end

When /^I add a "([^"]*)" feature with:$/ do |name, text|
  App.open_file("features/#{name.downcase.gsub(' ', '_')}.feature", 'w') do |f|
    f.write "Feature: #{name}\n\n"
    f.write text.split("\n").collect { |l| "  #{l}" }.join("\n")
  end
end

When /^I add the "([^"]*)" strategy to the middleware stack$/ do |strategy|
  app = File.read(File.join(App::ROOT, 'app.rb'))

  App.open_file('app.rb', 'w') do |f|
    f.write app.gsub(
      /(enable :sessions)/,
      "\\1\n\nuse OmniAuth::Strategies::#{strategy}, 'KEY', 'SECRET'"
    )
  end
end

When /^I add a link to "([^"]*)" with the text "([^"]*)" to the homepage$/ do |url, text|
  When "I add the following to my Sinatra app:",
    "get '/' do\n  '<a href=\"#{url}\">#{text}</a>'\nend"
end

When /^I add the following step definition to the user steps:$/ do |text|
  App.open_file('features/step_definitions/user_steps.rb', 'a') do |f|
    f.write "#{text}\n\n"
  end
end

When /^I add the following to my Sinatra app:$/ do |text|
  App.open_file('app.rb', 'a') do |f|
    f.write "\n#{text}\n"
  end
end

When /^I bundle the oa\-testing gem and require it in "([^"]*)"$/ do |file|
  App.open_file('Gemfile', 'a') do |f|
    f.write "gem 'oa-testing', path: '../..'"
  end

  file_data = File.read(File.join(App::ROOT, file))
  App.open_file(file, 'w') do |f|
    f.write file_data.sub(/(require '.*'\n)\n/, "\\1require 'oa-testing'\n\n")
  end
end

Then /^the features should pass$/ do
  RVM.gemset.use! 'oa-testing-test'

  cucumber_output = ''

  FileUtils.cd(App::ROOT) do
    cucumber_output = `BUNDLE_GEMFILE="#{App::ROOT}/Gemfile" cucumber`
  end

  if $?.exitstatus != 0
    raise cucumber_output
  end

  RVM.gemset.use! 'oa-testing'
end
