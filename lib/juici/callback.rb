require 'net/http'
module Juici
  class Callback

    attr_reader :url
    attr_accessor :payload

    def initialize(url)
      @url = url
    end

    def process!
      Net::HTTP.start(url.host, url.port) do |http|
        request = Net::HTTP::Post.new(url.request_uri)
        request.body = payload

        http.request request # Net::HTTPResponse object
      end
    end

  end
end
