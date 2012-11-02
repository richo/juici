require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juici build abstraction" do

  before(:all) do
    @app = Juici::App.new
  end

  after(:all) do
    Juici::App.shutdown
  end


  it "Should run a given command in a subshell" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "/bin/echo 'test build succeeded'")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    sleep 2

    build.reload
    build[:status].should == :success
    build[:output].chomp.should == "test build succeeded"
  end

  it "Should catch failed builds" do
    watcher = Juici::Watcher.instance.start
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "exit 3")
    $build_queue << build

    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    sleep 2

    build.reload
    build[:status].should == :failed
    build[:output].chomp.should == ""
  end

end
