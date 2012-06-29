require 'fileutils'
require 'tempfile'
module Juicy
   module BuildLogic

    def spawn_build
      raise "No such work tree" unless FileUtils.mkdir_p(worktree)
      spawn(command, worktree)
    end

  private

    def spawn(cmd, dir)
      @buffer = Tempfile.new('juicy-xxxx')
      Process.spawn(environment, cmd,
        :chdir => dir,
        :in  => "/dev/null",
        :out => @buffer.fileno,
        :err => [:child, :out]
      )
    end

  end
end
