module Juici
  class Watcher < Thread

    def self.start!
      new do
        self.mainloop
      end
    end

    def self.mainloop
      #XXX No classvariables ever!
      loop do
        begin
          pid, status = catch_child
        rescue Errno::ECHILD
          # No children available, sleep for a while until some might exist
          # TODO: It'd be a nice optimisation to actually die here, and
          # optionally start a worker if we're the first child
          sleep 5
          next
        end
        next unless pid
        build = $build_queue.get_build_by_pid(pid)

        if status == 0
          build.success!
        else
          build.failure!
        end
        $build_queue.bump! if $build_queue
      end
    end

    # Hook for testing
    def self.catch_child
      Process.wait2(-1, Process::WNOHANG)
    end

  end
end
