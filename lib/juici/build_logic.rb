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
      Process.spawn(environment, cmd,
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

  end
end
