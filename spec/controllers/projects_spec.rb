require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Controllers::Builds do

  describe "search" do
    it "Should find builds when they exist" do
      ::Juici::Project.find_or_create_by(name: "projects_spec_build")
      Juici::Build.where(title: "test_build_title").map(&:destroy)
      5.times do
        Juici::Build.new(parent: "projects_spec_build", priority: 1, title: "test_build_title").save!
      end

      controller = Juici::Controllers::Projects.new({ :project => "projects_spec_build", :build_title => "test_build_title"})
      controller.search do |template, opts|
        opts[:builds].length.should == 5
      end
    end
  end

end
