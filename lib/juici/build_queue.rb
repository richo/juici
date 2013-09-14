# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juici
  class BuildQueue

    def initialize
      @builds = []
      @child_pids = []
      # This is never expired, for now
      @builds_by_pid = {}
      @started = false
    end

    def shutdown!
      @child_pids.each do |pid|
        ::Juici.dbgp "Killing off child pid #{pid}"
        Process.kill(15, pid)
      end
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

    def candidate_children
      @builds.sort do |a, b|
        if a.priority == b.priority
          a.create_time <=> b.create_time
        else
          a.priority <=> b.priority
        end
      end
    end

    def purge(by, build)
      @builds.reject! do |i|
        build.send(by) == i.send(by)
      end
    end

    def delete(id)
      purge(:_id, OpenStruct.new(:_id => id))
    end

    # Magic hook that starts a process if there's a good reason to.
    # Stopgap measure that means you can knock on this if there's a chance we
    # should start a process
    def bump!
      return unless @started
      update_children

      candidate_children.each do |child|
        next if @child_pids.any? do |pid|
          get_build_by_pid(pid).parent == child.parent
        end

        # We're good to launch this build
        Juici.dbgp "Starting another child process"
        return child.tap do |cld|
          if pid = cld.build!
            Juici.dbgp "Started child: #{pid}"
            @child_pids << pid
            @builds_by_pid[pid] = cld
          else
            Juici.dbgp "Child #{cld} failed to start"
            bump! # Ruby's recursion isn't great, but re{try,do} may as well be
                  # undefined behaviour here.
          end
        end
      end
      Juici.dbgp "I have quite enough to do"
    end

    def update_children
      @child_pids.select! do |pid|
        return false if pid.nil?
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

    def currently_building
      @child_pids.map do |pid|
        get_build_by_pid(pid)
      end
    end

    def start!
      @started = true
      bump!
    end

    def builds
      @builds
    end

    def reload!
      @builds.each(&:reload)
    end

  end
end
