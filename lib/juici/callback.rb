require 'net/http'
module Juici
  class Callback

    attr_reader :build, :url

    def initialize(build, url)
      @build = build
      @url = URI(url)
    end

    def process!
      Net::HTTP.post_form(url, build.to_form_hash)
    end

  end
end
