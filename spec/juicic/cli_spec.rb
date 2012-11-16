require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::CLI do
  it "Should send to the first action" do
    Juici::CLI.expects(:build)
    Juici::CLI.main(["build"])
  end
end
