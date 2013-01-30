require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Build do

  describe "Time elapsed" do
    it "Should have the total duration if complete" do

      build = Juici::Build.new
      Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5005))
      build.start!
      build.success!

      build.time_elapsed.to_i.should == 5
      build.destroy
    end

    it "Should have the time running if started" do
      build = Juici::Build.new
      Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5006))
      build.start!

      build.time_elapsed.to_i.should == 6
      build.destroy
    end

    it "Should be nil if not started" do
      build = Juici::Build.new
      build.time_elapsed.should be_nil
      build.destroy
    end
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
    build[:output] = "Lol, I has an output"
    build[:buffer] = "/tmp/buffer/lol"
    new_build = Juici::Build.new_from(build)

    Juici::Build::CLONABLE_FIELDS.each do |k|
      build[k].should == new_build[k]
    end

    build[:_id].should_not == new_build[:_id]
    new_build[:output].should be_nil
    new_build[:buffer].should be_nil
    build.destroy
    new_build.destroy
  end

  it "Should set PWD in environment to the worktree" do
    build = Juici::Build.new({:parent => "SometestBuild"})
    build[:environment] = ::Juici::BuildEnvironment.new.to_hash
    build.environment["PWD"].should == build.worktree
    build.destroy
  end

end
