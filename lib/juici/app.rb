at_exit do
  Juici::App.shutdown
end

module Juici
  class App
    @@watchers = []

    def self.shutdown
      ::Juici.dbgp "Shutting down Juici"
      @@watchers.each do |watcher|
        ::Juici.dbgp "Killing #{watcher.inspect}"
        watcher.kill
        watcher.join
        ::Juici.dbgp "Dead:   #{watcher.inspect}"
      end

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
      start_workers
    end

    def spawn_watcher
      @@watchers << Watcher.start!
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

    def start_workers
      no_workers = opts[:workers] || 1
      warn "More than 1 worker is liable to do strange things" if no_workers > 1
      no_workers.times do
        spawn_watcher
      end
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
