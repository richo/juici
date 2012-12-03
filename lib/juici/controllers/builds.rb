module Juici::Controllers
  class Builds < Base

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0

      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])

      builds = ::Juici::Build.where(workspace: project.name)

      pages = (builds.count.to_f / ::Juici::Config.builds_per_page).ceil

      builds = builds.desc(:_id).
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", build_opts({:project => project, :builds => builds, :pages => pages})]
    end

    def show
      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: project.name, _id: params[:id])
      # return 404 unless project && build
      yield [:"builds/show", build_opts({:project => project, :build => build})]
    end

    def kill
      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: project.name, _id: params[:id])

      ::Juici.dbgp "Killing off build #{build[:_id]}"
      build.kill! if build.status == ::Juici::BuildStatus::START
      return build
    end

    def cancel
      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: project.name, _id: params[:id])

      ::Juici.dbgp "Cancelling build #{build[:_id]}"
      build.cancel if build.status == ::Juici::BuildStatus::WAIT
      return build
    end

    def new
      yield [:"builds/new", {:active => :new_build}]
    end

    def styles
      ["builds"]
    end

    def edit
      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: project.name, _id: params[:id])
      # return 404 unless project && build
      yield [:"builds/edit", {:project => project, :build => build}]
    end

    def update!
      project = ::Juici::Workspace.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: project.name, _id: params[:id])

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
