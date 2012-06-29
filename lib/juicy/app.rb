module Juicy
  class App
    @@watchers = []

    def self.shutdown
      @@watchers.each do |watcher|
        watcher.shutdown!
        watcher.join
      end

      shutdown_build_queue
    end

    def initialize
      # NOTE: this happening before we start a build queue is important, it
      # means we can't start any more workers and get tied in knots
      # clear_stale_children
      spawn_watcher
      # Urgh
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

  end
end
