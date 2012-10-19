require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juici::App do
  it "instanciates cleanly and exits cleanly" do
    app = Juici::App.new
    Juici::App.shutdown
  end
end
