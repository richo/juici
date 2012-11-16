module Juici
  class Args
    attr_reader :action, :opts
    def initialize(argv)
      @opts = {}
      @action = argv.shift.to_sym

      until argv.empty?
        case argv.shift
        when "--command"
          command = argv.shift
          opts[:command] = if command == "-"
                                File.read(command)
                              else
                                command
                              end
        when "--host"
          opts[:host] = argv.shift
        when "--title"
          opts[:title] = argv.shift
        when "--project"
          opts[:project] = argv.shift
        when "--priority"
          opts[:priority] = argv.shift
        end
      end
    end
  end
end
