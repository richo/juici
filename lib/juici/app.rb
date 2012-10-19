at_exit do
  Juici::App.shutdown
end

module Juici
  class App
    @@watchers = []

    def self.shutdown
      ::Juici.dbgp "Shutting down Juici"
      ::Juici::Watcher.instance.shutdown!

      shutdown_build_queue
    end

    attr_reader :opts
    def initialize(opts={})
      Database.initialize!
      @opts = opts
      # NOTE: this happening before we start a build queue is important, it
      # means we can't start any more workers and get tied in knots
      # clear_stale_children
      #
      # Urgh
      init_build_queue
      reload_unfinished_work
      start_watcher
    end

  private

    def init_build_queue
      $build_queue ||= BuildQueue.new
    end

    def self.shutdown_build_queue
      if $build_queue
        $build_queue.shutdown!
        $build_queue = nil
      end

      # Find any remaining children and kill them
      # Ensure that any killed builds will be retried
    end

    def start_watcher
      ::Juici::Watcher.instance.start
    end

    def reload_unfinished_work
      # At this point no workers have started yet, we can safely assume that
      # :started means aborted
      Build.where(:status.in => [:started, :waiting]).each do |build|
        $build_queue << build
      end
    end

  end
end
