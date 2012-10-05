require 'net/http'
module Juici
  class Callback

    attr_reader :build, :url

    def initialize(build, url)
      @build = build
      @url = url
    end

    def process!
      Net::HTTP.post_form(url, build.to_form_hash)
    end

  end
end
