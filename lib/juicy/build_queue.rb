# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juicy
  class BuildQueue

    def initialize
      @builds = []
      @child_pids = []
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
      if @child_pids.length == 0
        next_child.build!
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

  end
end
