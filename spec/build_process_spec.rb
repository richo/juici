require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juicy build abstraction" do

  before(:all) do
    @app = Juicy::App.new
  end

  after(:all) do
    Juicy::App.shutdown
  end


  it "Should run a given command in a subshell" do
    build = Juicy::Build.new(parent: "test project",
                      environment: {},
                      command: "echo 'test build succeeded'")
    $build_queue << build
    # Deliberately don't push to mongo
    # build.save!
  end
end
