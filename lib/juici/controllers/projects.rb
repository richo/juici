module Juici::Controllers
  class Projects < Base

    def search
      project = ::Juici::Project.find_or_raise(NotFound, name: params[:project])
      builds  = ::Juici::Build.where(parent: project.name, title: params[:build_title])

      yield [:"builds/list", build_opts({:project => project, :builds => builds})]
    end

  end
end
