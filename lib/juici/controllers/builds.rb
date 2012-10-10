module Juici::Controllers
  class Builds < Base

    attr_accessor :params
    def initialize(params)
      @params = params
      @page = :builds
    end

    def list
      @action = :list
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
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", {:project => project, :builds => builds, :pages => pages}]
    end

    def show
      @action = :show

      project = ::Juici::Project.where(name: params[:project]).first
      build   = ::Juici::Build.where(parent: project.name, _id: params[:id]).first
      # return 404 unless project && build
      yield [:"builds/show", {:project => project, :build => build}]
    end

  end
end
