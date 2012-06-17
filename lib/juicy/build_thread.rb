require 'fileutils'
require 'tempfile'
module Juicy
  class BuildThread

    attr_reader :build
    def initialize(build)
      @build = build
      raise "No such work tree" unless FileUtils.mkdir_p(build.worktree)
    end

    def fire!
      build.start!
      Thread.new do |t|
        pid = spawn(build.command, build.worktree)
        Process.waitpid(pid)
        @buffer.rewind
        build[:output] = @buffer.read
        build.save!
        if $?.to_i == 0
          build.success!
        else
          build.failure!
        end
      end
    end

  private

    def spawn(cmd, dir)
      @buffer = Tempfile.new('juicy-xxxx')
      $stderr.puts "cmd: #{cmd}"
      $stderr.puts "dir: #{dir}"
      Process.spawn(build.environment, cmd,
        :chdir => dir,
        :in  => "/dev/null",
        :out => @buffer.fileno,
        :err => [:child, :out]
      )
    end

  end
end
