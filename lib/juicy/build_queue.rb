# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juicy
  class BuildQueue

    def initialize
      @builds = []
    end

    # Pushing a Build object into the BuildQueue is expressing that you want it run
    def <<(other)
      Juicy.dbgp "Build requested for #{other}"
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
