module Juicy
  class App
    @@watchers = []

    def self.shutdown
      @@watchers.each do |watcher|
        watcher.shutdown!
      end

      # Find any remaining children and kill them
      # Ensure that any killed builds will be retried
    end

    def initialize
      # NOTE: this happening before we start a build queue is important, it
      # means we can't start any more workers and get tied in knots
      # clear_stale_children
      spawn_watcher
      # Urgh
      $build_queue ||= BuildQueue.new

    end

    def spawn_watcher
      @@watchers << Watcher.start!
    end

  end
end
