module Juicy
  class Watcher < Thread

    def self.start!
      new do
        self.mainloop
      end
    end

    def shutdown!
      self.kill
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

        build = Build.where(status: :started,
                            pid: pid).first
        if status == 0
          build.success!
        else
          build.failure!
        end
      end
    end

    # Hook for testing
    def self.catch_child
      Process.wait2(-1, Process::WNOHANG)
    end

  end
end
