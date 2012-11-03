module Juici::Controllers
  class Base

    NotFound = Sinatra::NotFound

    attr_accessor :params
    def initialize(params)
      @params = params
      if params[:_user] && params[:_project]
        params[:project] = "#{params[:_user]}/#{params[:_project]}"
      end
    end

    def build_opts(opts)
      default_opts.merge(opts)
    end

    def default_opts
      {
        :styles => styles
      }
    end

    def styles
      []
    end

  end
end
