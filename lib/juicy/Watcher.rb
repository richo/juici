module Juicy
  class Watcher < Thread

    def self.start!
      new do
        mainloop
      end
    end

    def shutdown!
      self.kill
    end

    def mainloop
      loop do
        pid = Process.wait
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
  end
end
