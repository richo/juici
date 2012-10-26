module Juici::Controllers
  class BuildQueue < Base

    def list
      builds = BUILD_QUEUE.builds.sort_by(&:priority)
      yield [:"queue/list", opts(:builds => builds)]
    end

    def opts(_opts={})
      {:active => :queue}.merge(_opts)
    end

  end
end
