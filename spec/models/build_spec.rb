require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Build do

  describe "Time elapsed" do
    it "Should have the total duration if complete" do

      build = Juici::Build.new
      Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5005))
      build.start!
      build.success!

      build.time_elapsed.to_i.should == 5
    end

    it "Should have the time running if started" do
      build = Juici::Build.new
      Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5006))
      build.start!

      build.time_elapsed.to_i.should == 6
    end

    it "Should be nil if not started" do
      build = Juici::Build.new
      build.time_elapsed.should be_nil
    end

  end
end
