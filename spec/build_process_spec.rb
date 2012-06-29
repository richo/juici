require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juicy build abstraction" do

  before(:all) do
    @app = Juicy::App.new(workers: 0)
  end

  after(:all) do
    Juicy::App.shutdown
  end


  it "Should run a given command in a subshell" do
    worker = Juicy::Watcher.start!
    build = Juicy::Build.new(parent: "test project",
                      environment: {},
                      command: "echo 'test build succeeded'")
    $build_queue << build
    # Wait a reasonable time for build to finish
    # TODO: This can leverage the hooks system
    # TODO: Easer will be to have worker.block or something
    sleep 5
    build[:status].should == :success
  end

end
