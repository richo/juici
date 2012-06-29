# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juicy
  class BuildQueue

    def initialize
      @builds = []
    end

    def shutdown!
      # TODO
      # Handle killing off all running jobs and dealing with their state
    end

    # Pushing a Build object into the BuildQueue is expressing that you want it run
    def <<(other)
    end

    def current_min_priority
      @builds.collect(&:priority).compact.min || 1
    end

    def purge(by, build)
      @builds.reject! do |i|
        build.send(by) == i.send(by)
      end
    end

  end
end
