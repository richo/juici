module Juici
  module Router
    include Routes

    def build_new_path
      "/builds/new"
    end

    def build_list_path
      %r{^/builds/(?<project>[\w\/]+)/list$}
    end

    def build_rebuild_path
      %r{^/builds/(?<project>[\w\/]+)/rebuild/(?<id>[^/]*)$}
    end

    def build_edit_path
      %r{^/builds/(?<project>[\w\/]+)/edit/(?<id>[^/]*)$}
    end

    def build_show_path
      %r{^/builds/(?<project>[\w\/]+)/show/(?<id>[^/]*)$}
    end

    def build_trigger_path
      %r{^/trigger/(?<project>[\w\/]+)$}
    end

  end
end
