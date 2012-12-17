module Juici
  module Router
    include Routes
    URL_PART = /[\w\/. %]+/

    def build_new_path
      "/builds/new"
    end

    def build_list_path
      %r{^/builds/(?<project>#{URL_PART})/list$}
    end

    def build_rebuild_path
      %r{^/builds/(?<project>#{URL_PART})/rebuild/(?<id>[^/]*)$}
    end

    def build_edit_path
      %r{^/builds/(?<project>#{URL_PART})/edit/(?<id>[^/]*)$}
    end

    def build_show_path
      %r{^/builds/(?<project>#{URL_PART})/show/(?<id>[^/]*)$}
    end

    def build_output_path
      %r{^/builds/(?<project>#{URL_PART})/(?<id>[^/]*)/_output$}
    end

    def build_trigger_path
      %r{^/trigger/(?<project>#{URL_PART})$}
    end

  end
end
