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

end
