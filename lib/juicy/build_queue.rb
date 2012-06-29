# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juicy
  class BuildQueue

    def initialize
      @builds = []
      @child_pids = []
      # This is never expired, for now
      @builds_by_pid = {}
    end

    def shutdown!
      # TODO
      # Handle killing off all running jobs and dealing with their state
    end

    # Pushing a Build object into the BuildQueue is expressing that you want it
    # run
    def <<(other)
      @builds << other
      bump!
    end

    def current_min_priority
      @builds.collect(&:priority).compact.min || 1
    end

    def next_child
      @builds.sort_by(&:priority).first
    end

    def purge(by, build)
      @builds.reject! do |i|
        build.send(by) == i.send(by)
      end
    end

    # Magic hook that starts a process if there's a good reason to.
    # Stopgap measure that means you can knock on this if there's a chance we
    # should start a process
    def bump!
      update_children
      if not_working? && work_to_do?
        Juicy.dbgp "Starting another child process"
        next_child.tap do |child|
          pid = child.build!
          @child_pids << pid
          @builds_by_pid[pid] = child
        end
      else
        Juicy.dbgp "I have quite enough to do"
      end
    end

    def update_children
      @child_pids.select! do |pid|
        begin
          Process.kill(0, pid)
          true
        rescue Errno::ESRCH
          false
        end
      end
    end

    def get_build_by_pid(pid)
      @builds_by_pid[pid]
    end

    def not_working?
      @child_pids.length == 0
    end

    def work_to_do?
      @builds.length > 0
    end

  end
end
