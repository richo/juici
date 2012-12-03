module Juici
  module BuildStatus
    PASS = "success"
    FAIL = "failed"
    START = "started"
    WAIT = "waiting"
  end

  module Routes extend self
    NEW_BUILD = '/builds/new'

    def build_list(project)
      "/builds/#{project}/list"
    end

    def build_rebuild(project, build)
      "/builds/#{project}/rebuild/#{build}"
    end

    def build_edit(project, build)
      "/builds/#{project}/edit/#{build}"
    end

    def build_show(project, build)
      "/builds/#{project}/show/#{build}"
    end

    def build_trigger(project)
      "/trigger/#{project}"
    end
  end

end
