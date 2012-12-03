module Juici::Controllers
  class Builds < Base

    def list
      params[:page] = params[:page] ? params[:page].to_i : 0

      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])

      builds = ::Juici::Build.where(workspace: workspace.name)

      pages = (builds.count.to_f / ::Juici::Config.builds_per_page).ceil

      builds = builds.desc(:_id).
        limit(::Juici::Config.builds_per_page).
        skip(params[:page].to_i * ::Juici::Config.builds_per_page)

      yield [:"builds/list", build_opts({:workspace => workspace, :builds => builds, :pages => pages})]
    end

    def show
      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: workspace.name, _id: params[:id])
      yield [:"builds/show", build_opts({:workspace => workspace, :build => build})]
    end

    def kill
      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: workspace.name, _id: params[:id])

      ::Juici.dbgp "Killing off build #{build[:_id]}"
      build.kill! if build.status == ::Juici::BuildStatus::START
      return build
    end

    def cancel
      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: workspace.name, _id: params[:id])

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
      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: workspace.name, _id: params[:id])
      yield [:"builds/edit", {:workspace => workspace, :build => build}]
    end

    def update!
      workspace = ::Juici::Workspace.find_or_raise(NotFound, name: params[:workspace])
      build   = ::Juici::Build.find_or_raise(NotFound, workspace: workspace.name, _id: params[:id])

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
