require File.expand_path(File.dirname(__FILE__) + '/helper')

def new_app
  Juici::App.new
end

def shutdown
  Juici::App.shutdown
end

class TestBuildProcess < Test::Unit::TestCase
  def test_runs_commands_in_subshells
    app = new_app

    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "/bin/echo 'test build succeeded'")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    sleep 1

    build.reload
    assert_equal(build[:status], :success)
    assert_equal(build[:output].chomp, "test build succeeded")

    shutdown
  end

  # def test_catches_failed_builds
  #   app = new_app

  #   watcher = Juici::Watcher.instance.start
  #   build = Juici::Build.new(parent: "test project",
  #                     environment: {},
  #                     command: "exit 3")
  #   $build_queue << build

  #   # Wait a reasonable time for build to finish
  #   # TODO: This can leverage the hooks system
  #   # TODO: Easer will be to have worker.block or something
  #   sleep 1

  #   build.reload
  #   assert_equal(build[:status], :failed)
  #   assert_equal(build[:output].chomp, "")

  #   shutdown
  # end
end
