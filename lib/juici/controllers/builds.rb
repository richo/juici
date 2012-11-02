module Juici::Controllers
  class Builds < Base

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0
      pages = {}

      if params[:page] > 0
        pages[:prev] = params[:page] - 1
      end
      #if lol
      pages[:next] = params[:page] + 1
      #end

      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])

      builds = ::Juici::Build.where(parent: project.name).
        desc(:_id).
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", build_opts({:project => project, :builds => builds, :pages => pages})]
    end

    def show
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])
      # return 404 unless project && build
      yield [:"builds/show", build_opts({:project => project, :build => build})]
    end

    def kill
      unless project = ::Juici::Project.where(name: params[:project]).first
        not_found
      end
      build   = ::Juici::Build.where(parent: project.name, _id: params[:id]).first
      ::Juici.dbgp "Killing off build #{build[:_id]}"
      build.kill! if build[:status] == :started
      return build
    end

    def new
      yield [:"builds/new", {:active => :new_build}]
    end

    def styles
      ["builds"]
    end

  end
end
