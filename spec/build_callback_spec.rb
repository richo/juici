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
    build.destroy
  end

  # TODO DRY This right up
  it "should have status success on success" do
    cb = Juici::Callback.new("test")
    cb.stubs(:process!)

    Juici::Callback.stubs(:new).with("test").returns(cb)

    build = Juici::Build.new(:callbacks => ["test"])
    build.start!
    build.success!

    JSON.load(cb.payload)["status"].should == "success"
    build.destroy
  end

  it "should have status failed on failure" do
    cb = Juici::Callback.new("test")
    cb.stubs(:process!)

    Juici::Callback.stubs(:new).with("test").returns(cb)

    build = Juici::Build.new(:callbacks => ["test"])
    build.start!
    build.failure!

    JSON.load(cb.payload)["status"].should == "failed"
    build.destroy
  end

end
