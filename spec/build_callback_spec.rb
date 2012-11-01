require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juicy::Build::Callback" do

  it "should call #process! on each of it's callbacks" do
    def mock_callback
      mock(:payload= => nil).tap do |callback|
        callback.expects(:process!).once
      end
    end

    callbacks = ["rawr", "test"]

    callbacks.each do |callback|
      Juici::Callback.stubs(:new).with(callback).
        returns(mock_callback)
    end

    build = Juici::Build.new(:callbacks => callbacks)
    build.start!
    build.success!
  end

end
