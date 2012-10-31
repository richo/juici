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

    it "Should clone itself with #new_from" do
      values = {}
      Juici::Build::CLONABLE_FIELDS.each do |k|
        case k
        when :environment
          values[k] = {:something => "#{k}_value"}
        else
          values[k] = "#{k}_value"
        end
      end

      build = Juici::Build.new(values)
      new_build = Juici::Build.new_from(build)

      Juici::Build::CLONABLE_FIELDS.each do |k|
        build[k].should == new_build[k]
      end

      build[:_id].should_not == new_build[:_id]
    end
  end
end
