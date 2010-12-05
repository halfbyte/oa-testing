require File.join(File.dirname(__FILE__), 'lib/oa-testing/version')

Gem::Specification.new do |s|
  s.name    = 'oa-testing'
  s.version = OmniAuth::Testing::VERSION

  s.summary     = 'Aids integration testing of OmniAuth functionality.'
  s.description = 'Aids integration testing of OmniAuth functionality in your app by providing fake responses through FakeWeb for various providers such as Twitter, Facebook, OpenID, etc.'
  s.homepage    = 'http://github.com/insaneinnovation/oa-testing'

  s.author = 'David Trasbo'
  s.email  = 'dtrasbo@insaneinnovation.org'

  s.files = ['README.md', 'LICENSE'] + Dir['lib/**/*']

  s.add_dependency 'omniauth', '~> 0.1.0'
  s.add_dependency 'fakeweb',  '~> 1.3.0'

  s.add_development_dependency 'cucumber', '~> 0.9.0'
  s.add_development_dependency 'rspec',    '~> 1.3.0'
end
