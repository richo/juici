require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juici::App do
  it "instanciates cleanly and exits cleanly" do
    threads = Thread.list.length

    app = Juici::App.new
    Thread.list.length.should == threads + 1

    Juici::App.shutdown
    Thread.list.length.should == threads
  end

  it "Can be started without workers" do
    threads = Thread.list.length

    app = Juici::App.new(workers: 0)
    Thread.list.length.should == threads

    Juici::App.shutdown
    Thread.list.length.should == threads
  end
end
