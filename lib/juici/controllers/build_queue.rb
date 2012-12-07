module Juici::Controllers
  class BuildQueue < Base

    def list
      builds = $build_queue.builds.sort_by(&:priority)
      yield [:"queue/list", opts(:builds => builds)]
    end

    def opts(_opts={})
      {:active => :queue}.merge(_opts)
    end

    def styles
      ["builds"]
    end

  end
end
