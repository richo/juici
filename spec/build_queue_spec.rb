require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juicy::BuildQueue do

  subject { Juicy::BuildQueue.new.tap { |q| q.__builds = @builds } }

  it "Should return 1 as min priority when empty" do
    @builds = []
    subject.current_min_priority.should == 1
  end

  it "Should return the min priority when set" do
    @builds = builds_with(priority: [ 5, 3, 7 ])
    subject.current_min_priority.should == 3
  end

  it "Should deal gracefully with nil" do
    @builds = builds_with(priority: [ 5, 4, nil,  7 ])
    subject.current_min_priority.should == 4
  end

  it "Should remove a given build by pid by pid" do
    # Build an array of
    @builds = builds_with(pid: [1, 2, 3, 4, 5, 6])
    subject.purge(:pid, stub(:pid => 3))
    @builds.collect(&:pid).should == [1, 2, 4, 5, 6]
  end

  it "Should silently fail to remove nonexistant pids by pid" do
    @builds = builds_with(pid: [1, 2, 3, 4, 5, 6])
    subject.purge(:pid, stub(:pid => 9))
    @builds.collect(&:pid).should == [1, 2, 3, 4, 5, 6]
  end

end

class Juicy::BuildQueue #{{{ Test injection
  def __builds=(builds)
    @builds = builds
  end
end #}}}

def builds_with(args)
  args.map do |k, v|
    v.map do |i|
      stub(k => i)
    end
  end.flatten
end

