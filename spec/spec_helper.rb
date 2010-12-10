require 'bundler/setup'
require 'oa-testing'

FakeWeb.allow_net_connect = false

class FakeResponse
  def self.for(*args)
    new(*args)
  end

  def initialize(method, uri)
    @request_class = Net::HTTP.const_get(method[0] + method[1..-1].downcase)
    @uri = URI.parse(uri)
  end

  def registered?
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    request = @request_class.new(@uri.request_uri)

    begin
      http.request(request)
    rescue
      return false
    end
    true
  end
end
