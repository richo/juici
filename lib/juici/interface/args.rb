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
          options[:command] = if command == "-"
                                File.read(command)
                              else
                                command
                              end
        when "--host"
          options[:host] = argv.shift
        when "--title"
          options[:title] = argv.shift
        when "--project"
          options[:project] = argv.shift
        when "--priority"
          options[:priority] = argv.shift
        end
      end
    end
  end
end
