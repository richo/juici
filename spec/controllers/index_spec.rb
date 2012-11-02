require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Controllers::Index do

  describe "index" do
    it "should render index" do
      Juici::Controllers::Index.new().index do |template, opts|
      end
    end
  end

  describe "about" do
    it "should add block-header to all h1 tags" do
      Juici::Controllers::Index.new().about do |template, opts|
        opts[:content].should match(/class="block-header"/)
      end
    end
  end

  describe "support" do
    it "should render support" do
      Juici::Controllers::Index.new().support do |template, opts|
      end
    end
  end

end

