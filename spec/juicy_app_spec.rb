require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juicy::App do
  it "instanciates cleanly and exits cleanly" do
    threads = Thread.list.length

    app = Juicy::App.new
    Thread.list.length.should == threads + 1

    Juicy::App.shutdown
    Thread.list.length.should == threads
  end
end
