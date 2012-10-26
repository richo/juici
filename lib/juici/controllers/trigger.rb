module Juici::Controllers
  class Trigger

    attr_reader :project, :params
    def initialize(project, params)
      @project = ::Juici::Project.find_or_create_by(name: project)
      @params = params
    end

    def build!
      environment = ::Juici::BuildEnvironment.new
      ::Juici::Build.new(parent: project.name).tap do |build|
        # The seperation of concerns around this madness is horrifying
        unless environment.load_json!(params['environment'])
          build.warn!("Failed to parse environment")
        end

        build[:command] = build_command
        build[:priority] = build_priority
        build[:environment] = environment.to_hash
        build[:callbacks] = callbacks
        build[:title] = title if title_given?

        build.save!
        BUILD_QUEUE << build
      end
    end

    # These accessors are not really the concern of a "Controller". On the
    # other hand, this thing is also not a controller realistically, so I'm
    # just going to carry on using this as a mechanism to poke at my model.
    #
    # I later plan to implement a more strictly bounded interface which bails
    # instead of coercing.
    def build_command
      # TODO Throw 422 not acceptable if missing
      params['command'].tap do |c|
        raise "No command given" if c.nil?
        # TODO Detect that we've recieved this from a browser session and only
        # do this replacement there, we can trust API supplied data.
        c.gsub!(/\r\n/, "\n")
      end
    end

    def build_priority
      if params['priority'] =~ /^[0-9]+$/
        params['priority'].to_i
      else
        1
      end
    end

    def callbacks
      JSON.load(params['callbacks'])
    rescue
      []
    end

    def title
      params['title']
    end

    def title_given?
      t = params['title']
      !(t.nil? || t.empty?)
    end

  end
end
