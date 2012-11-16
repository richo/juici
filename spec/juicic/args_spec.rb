require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juici::Args do
  %w[host title project priority].each do |arg|
    it "Parses --#{arg}" do
      a = Juici::Args.new(%W[test --#{arg} sample_argument])
      a.opts[arg.to_sym].should == "sample_argument"
    end
  end
end
