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

    def output
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])
      # return 404 unless project && build
      yield build
    end

    def kill
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])

      ::Juici.dbgp "Killing off build #{build[:_id]}"
      build.kill! if build.status == ::Juici::BuildStatus::START
      return build
    end

    def cancel
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      build   = ::Juici::Build.find_or_raise(NotFound, parent: project.name, _id: params[:id])

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
      build.tap do |b|
        b.save!
        $build_queue.reload! if $build_queue
      end
    end

  end
end
