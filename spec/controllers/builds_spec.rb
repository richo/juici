require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Controllers::Builds do

  describe "list" do
    it "should throw not_found for invalid projects" do
      params = { :project => "__LolIDon'tExist" }
      lambda {
        Juici::Controllers::Builds.new(params).list
      }.should raise_error(Sinatra::NotFound)
    end
  end

  describe "show" do
    it "should throw not_found for invalid projects" do
      params = { :project => "__LolIDon'tExist" }
      lambda {
        Juici::Controllers::Builds.new(params).show
      }.should raise_error(Sinatra::NotFound)
    end
  end

  describe "new" do
    it "should return the new template" do
      Juici::Controllers::Builds.new({}).new do |opts, template|
      end
    end
  end

  describe "edit" do
    it "should throw not_found for invalid projects" do
      params = { :project => "__LolIDon'tExist" }
      lambda {
        Juici::Controllers::Builds.new(params).show
      }.should raise_error(Sinatra::NotFound)
    end

    it "Should update build objects when given data" do
      # FIXME This is a kludge to work around #38
      ::Juici::Project.find_or_create_by(name: "test project")
      build = Juici::Build.new(parent: "test project", priority: 1, title: "test build")
      build.save!

      # Succeed this build so it isn't retried.
      build.success!

      Juici::Controllers::Builds.new({:priority => 15, :title => "butts lol", :id => build[:_id], :project => "test project"}).update!
      build.reload

      build[:title].should == "butts lol"
      build[:priority].should == 15
    end

    it "Should not let you update a build's ID" do
      # FIXME This is a kludge to work around #38
      ::Juici::Project.find_or_create_by(name: "test project")
      build = Juici::Build.new(parent: "test project")
      build.save!
      #
      # Succeed this build so it isn't retried.
      build.success!

      updated_build = Juici::Controllers::Builds.new({:_id => "New id lol", :id => build[:_id], :project => "test project"}).update!

      updated_build[:_id].should == build[:_id]
    end

    it "Should not touch values if given invalid values" do
      pending("Needs more research on mongoid")
    end

  end
end
