module Juici::Controllers
  class Builds < Base

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0

      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])

      builds = ::Juici::Build.where(parent: project.name)

      pages = (builds.count.to_f / ::Juici::Config.builds_per_page).ceil

      builds = builds.desc(:_id).
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

    def edit
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])
      # return 404 unless project && build
      yield [:"builds/edit", {:project => project, :build => build}]
    end

    def update!
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])

      ::Juici::Build::EDITABLE_ATTRIBUTES[:string].each do |attr|
        build[attr] = params[attr] if params[attr]
      end
      # binding.pry
      build.tap do |b|
        b.save!
      end
    end

  end
end
