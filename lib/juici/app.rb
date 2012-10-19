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
      @opts = opts
      reset_stale_children
      start_watcher
      init_build_queue
      reload_unfinished_work
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
      Build.where(:status => :waiting).each do |build|
        $build_queue << build
      end
    end

    def reset_stale_children
      Build.where(:status => :started).each do |build|
        build[:status] = :waiting
        build.save!
      end
    end

  end
end
