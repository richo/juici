require 'net/http'
module Juici
  class Callback

    attr_reader :url
    attr_accessor :payload

    def initialize(url, pl=nil)
      @url = URI(url)
      @payload = pl if pl
    end

    def process!
      Net::HTTP.start(url.host, url.port) do |http|
        request = Net::HTTP::Post.new(url.request_uri)
        if url.scheme == "https"
          http.use_ssl = true
        end

        request.body = payload

        http.request request # Net::HTTPResponse object
      end
    rescue SocketError => e
      # We don't get a reference to build any more, can't warn :(
      # TODO Throw a warning on the build
    end

  end
end
