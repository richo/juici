require 'fileutils'
require 'tempfile'
module Juici
  module BuildLogic

    def spawn_build
      raise "No such work tree" unless FileUtils.mkdir_p(worktree)
      spawn(command, worktree)
    rescue AbortBuild
      :buildaborted
    end

    def kill!
      warn! "Killed!"
      if pid = self[:pid]
        Process.kill(15, pid)
      end
    end

  private

    def spawn(cmd, dir)
      @buffer = Tempfile.new('juici-xxxx')
      Process.spawn(environment, parse_cmd(cmd),
        :chdir => dir,
        :in  => "/dev/null",
        :out => @buffer.fileno,
        :err => [:child, :out]
      )
    rescue Errno::ENOENT
      :enoent
    rescue TypeError
      :invalidcommand
    end

    def parse_cmd(cmd)
      first_line = cmd.lines.first.chomp
      if first_line.start_with?("#!")
        scriptfile = Tempfile.new('juici-cmd')
        scriptfile.write(cmd)
        scriptfile.close
        real_cmd = "#{first_line[2..-1]} #{scriptfile.path}"
      else
        real_cmd = cmd
      end
    end

  end
end
