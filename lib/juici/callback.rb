require 'net/http'
module Juici
  class Callback

    attr_reader :build, :url

    def initialize(build, url)
      @build = build
      @url = URI(url)
    end

    def process!
      Net::HTTP.start(url.host, url.port) do |http|
        request = Net::HTTP::Post.new(url.request_uri)
        request.body = build.to_callback_json

        response = http.request request # Net::HTTPResponse object
      end
    end

  end
end
