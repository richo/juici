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
        Juicy.dbgp "Waiting for a child to exit"
        pid = catch_child
        Juicy.dbgp "#{pid} exited"
        status = $?

          build = Build.where(status: :started,
                              pid: pid)
        if status == 0
          build.success!
        else
          build.failure!
        end
      end
    end

    # Hook for testing
    def self.catch_child
      Process.wait
    end

  end
end
