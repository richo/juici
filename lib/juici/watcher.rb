module Juici
  class Watcher

    def self.instance
      @@instance ||= self.new
    end

    def initialize
      @active = true
    end

    def register_handler
      Signal.trap("CHLD") do
        if @active
          pid, status = Process.wait2(-1)
          $build_queue.purge(:pid, OpenStruct.new(:pid => pid))
          ::Juici.dbgp "Trying to find pid: #{pid}"
          handle(pid, status)
        end
      end
    end

    def handle(pid, status)
      build = $build_queue.get_build_by_pid(pid)

      if status == 0
        build.success!
      else
        build.failure!
      end
      $build_queue.bump! if $build_queue
    end

    def shutdown!
      @active = false
    end

    def start
      register_handler
    end

  end
end
