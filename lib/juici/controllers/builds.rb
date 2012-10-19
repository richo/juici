module Juici::Controllers
  class Builds < Base

    attr_accessor :params
    def initialize(params)
      @params = params
    end

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0

      unless project = ::Juici::Project.where(name: params[:project]).first
        not_found
      end

      builds = ::Juici::Build.where(parent: project.name)

      pages = (builds.count.to_f / ::Juici::Config.builds_per_page).ceil

      builds = builds.desc(:_id).
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", build_opts({:project => project, :builds => builds, :pages => pages})]
    end

    def show
      unless project = ::Juici::Project.where(name: params[:project]).first
        not_found
      end
      build   = ::Juici::Build.where(parent: project.name, _id: params[:id]).first
      # return 404 unless project && build
      yield [:"builds/show", build_opts({:project => project, :build => build})]
    end

    def new
      yield [:"builds/new", {:active => :new_build}]
    end

  end
end
