module Juici
  module CLI extend self
    def main(argv)
      args = Args.new(argv)
      send(args.action, args.opts)
    end

    def build(opts)
      host = URI(opts[:host])
      Net::HTTP.start(host.host, host.port) do |h|
        req = Net::HTTP::Post.new(Juici::Routes::NEW_BUILD)
        req.body = _create_payload(opts)
        h.request req
      end
    end

    def _create_payload(opts)
      URI.encode_www_form({
        "project" => opts[:project],
        "environment" => (opts[:environment] || {}).to_json,
        "command" => opts[:command],
        "priority" => opts[:priority] || 1,
        "callbacks" => (opts[:callbacks] || []).to_json,
        "title" => opts[:title]
      })
    end
  end
end
