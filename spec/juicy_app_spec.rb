require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juicy::App do
  it "instanciates cleanly and exits cleanly" do
    threads = Thread.list.length

    app = Juicy::App.new
    Thread.list.length.should == threads + 1

    Juicy::App.shutdown
    Thread.list.length.should == threads
  end

  it "Can be started without workers" do
    threads = Thread.list.length

    app = Juicy::App.new(workers: 0)
    Thread.list.length.should == threads + 0

    Juicy::App.shutdown
    Thread.list.length.should == threads
  end
end
