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

    def intialize
      spawn_watcher
    end

    def spawn_watcher
      @@watchers << Watcher.new do
        loop do
          pid = Process.wait
          status = $?

          build = Build.where(status: :started,
                              pid: pid)
          if status == 0
            build.success!
          end
        end
      end
    end

  end
end
