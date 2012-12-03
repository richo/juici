module Juici
  module BuildStatus
    PASS = "success"
    FAIL = "failed"
    START = "started"
    WAIT = "waiting"
  end

  module Routes extend self
    NEW_BUILD = '/builds/new'

    def build_new
      NEW_BUILD
    end

    def build_list(workspace)
      "/builds/#{workspace}/list"
    end

    def build_rebuild(workspace, build)
      "/builds/#{workspace}/rebuild/#{build}"
    end

    def build_edit(workspace, build)
      "/builds/#{workspace}/edit/#{build}"
    end

    def build_show(workspace, build)
      "/builds/#{workspace}/show/#{build}"
    end

    def build_trigger(workspace)
      "/trigger/#{workspace}"
    end
  end

end
