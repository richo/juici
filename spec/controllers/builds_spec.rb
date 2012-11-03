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

      updated_build = Juici::Controllers::Builds.new({:_id => "New id lol", :id => build[:_id], :project => "test project"}).update!

      updated_build[:_id].should == build[:_id]
    end

    describe "environment" do
      it "should update the environment" do
        # FIXME This is a kludge to work around #38
        ::Juici::Project.find_or_create_by(name: "test project")
        build = Juici::Build.new(parent: "test project", environment: {"foo" => "bar"})
        build.save!

        Juici::Controllers::Builds.new({:id => build[:_id], :project => "test project", :environment => {"foo" => "thing", "bar" => "baz"}}).update!
        build.reload

        build[:environment]["foo"].should == "thing"
        build[:environment]["bar"].should == "baz"
      end

      it "shouldn't break nil keys in the environment" do
        # FIXME This is a kludge to work around #38
        ::Juici::Project.find_or_create_by(name: "test project")
        build = Juici::Build.new(parent: "test project", environment: {"foo" => nil})
        build.save!

        Juici::Controllers::Builds.new({:id => build[:_id], :project => "test project", :environment => {"foo" => "", "bar" => "baz"}}).update!
        build.reload

        build[:environment]["foo"].should be_nil
        build[:environment]["bar"].should == "baz"
      end


      it "Should not touch values if given invalid values" do
        pending("Needs more research on mongoid")
      end
    end

    describe "callbacks" do
      it "should update callbacks" do
        # FIXME This is a kludge to work around #38
        ::Juici::Project.find_or_create_by(name: "test project")
        build = Juici::Build.new(parent: "test project", environment: {"foo" => nil})
        build.save!

        Juici::Controllers::Builds.new({:id => build[:_id], :project => "test project", :callbacks => {"1" => "http://rawr", "2" => "butts lol"}}).update!
        build.reload

        build[:callbacks].should include("http://rawr", "butts lol")
      end

      it "should delete empty callbacks" do
        # FIXME This is a kludge to work around #38
        ::Juici::Project.find_or_create_by(name: "test project")
        build = Juici::Build.new(parent: "test project", environment: {"foo" => nil})
        build.save!

        Juici::Controllers::Builds.new({:id => build[:_id], :project => "test project", :callbacks => {"1" => "http://rawr", "2" => ""}}).update!
        build.reload

        build[:callbacks].length.should == 1
        build[:callbacks].should include("http://rawr")
      end
    end
  end
end
