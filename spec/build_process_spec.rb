require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juici build abstraction" do

  before(:all) do
    @app = Juici::App.new(workers: 0)
  end

  after(:all) do
    Juici::App.shutdown
  end


  it "Should run a given command in a subshell" do
    worker = Juici::Watcher.start!
    build = Juici::Build.new(parent: "test project",
                      environment: {},
                      command: "/bin/echo 'test build succeeded'")
    $build_queue << build
    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    sleep 5

    build.reload
    build[:status].should == :success
    build[:output].chomp.should == "test build succeeded"
  end

end
