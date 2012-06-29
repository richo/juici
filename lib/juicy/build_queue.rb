# An object representing a queue. It merely manages creating child processes
# and their priority, reaping them is a job for BuildThread
#
module Juicy
  class BuildQueue

    def initialize
      @builds = []
    end

  end
end
