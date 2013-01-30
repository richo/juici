require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Juici::BuildQueue do

  subject { Juici::BuildQueue.new.tap { |q| q.__builds = @builds } }

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

  it "Should remove a given build by id" do
    @builds = builds_with(_id: [1, 2, 3, 4, 5, 6])
    subject.delete(3)
    @builds.collect(&:_id).should == [1, 2, 4, 5, 6]
  end

  it "Should return a low priority job from #next_child" do
    @builds = builds_with(priority: [1, 2, 3, 4, 5, 6])
    subject.next_child.priority.should == 1
    @builds = builds_with(priority: [6, 5, 4, 3, 2, 1])
    subject.next_child.priority.should == 1
  end

  it "Should update build definitions on reload!" do
    @builds = []
    subject.reload!
    [1, 5].each do |priority|
      ::Juici::Project.find_or_create_by(name: "test project")
      build = Juici::Build.new(parent: "test project", priority: priority)
      build.save!
      subject << build
    end
    subject.next_child.priority.should == 1
    @builds[1].tap do |build|
      build.priority = -5
      build.save!
    end
    subject.reload!
    subject.next_child.priority.should == -5

    @builds.each(&:destroy)
  end

end

class Juici::BuildQueue #{{{ Test injection
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

