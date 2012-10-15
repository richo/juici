module Juici::Controllers
  class Builds < Base

    attr_accessor :params
    def initialize(params)
      @params = params
    end

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0
      pages = {}

      if params[:page] > 0
        pages[:prev] = params[:page] - 1
      end
      #if lol
      pages[:next] = params[:page] + 1
      #end

      project = ::Juici::Project.where(name: params[:project]).first
      builds  = ::Juici::Build.where(parent: project.name).
        desc(:_id).
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", build_opts({:project => project, :builds => builds, :pages => pages})]
    end

    def show
      project = ::Juici::Project.where(name: params[:project]).first
      build   = ::Juici::Build.where(parent: project.name, _id: params[:id]).first
      # return 404 unless project && build
      yield [:"builds/show", build_opts({:project => project, :build => build})]
    end

    def new
      yield [:"builds/new", {:active => :new_build}]
    end

    def styles
      ["builds"]
    end

  end
end
