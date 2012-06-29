module Juicy
  class App
    @@watchers = []

    def self.shutdown
      @@watchers.each do |watcher|
        watcher.kill
        watcher.join
      end

      shutdown_build_queue
    end

    attr_reader :opts
    def initialize(opts={})
      @opts = opts
      # NOTE: this happening before we start a build queue is important, it
      # means we can't start any more workers and get tied in knots
      # clear_stale_children
      #
      # Urgh
      start_workers
      init_build_queue
    end

    def spawn_watcher
      @@watchers << Watcher.start!
    end

  private

    def init_build_queue
      $build_queue ||= BuildQueue.new
    end

    def self.shutdown_build_queue
      $build_queue.shutdown!
      $build_queue = nil

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

  end
end
