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
      if pid = fork
        return pid
      else
        Posix.dup2(File.open("/dev/null", "r").fileno, STDIN.fileno)
        Posix.dup2(@buffer.fileno, STDOUT.fileno)
        Posix.dup2(STDOUT.fileno,  STDERR.fileno)

        Dir.chdir(dir)
        Posix.sigprocmask(Posix::SIG_BLOCK, sigmask)
        Posix.execve("/bin/sh", ["/bin/sh", "-c", cmd], environment)
        raise "Child process failed to launch"
      end
    rescue Errno::ENOENT
      :enoent
    rescue TypeError
      :invalidcommand
    end


    def sigmask
      Posix::Sigset.new << "INT"
    end

  end
end
