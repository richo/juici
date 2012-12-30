require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juici build logic" do

  describe "Shebangs" do
    before(:all) do
      testlogic = Class.new
      testlogic.include ::Juici::BuildLogic
      @logic = testlogic.new
    end

    it "Should parse shebang lines" do
      @logic.send(:parse_cmd, <<-EOS).should match %r{^/bin/cat /}
#!/bin/cat
#
rawr lols
EOS
    end

    it "Shouldn't touch nonshebang lines" do
      script = <<-EOS
echo lols
echo butts
EOS
      @logic.send(:parse_cmd, script).should == script
    end
  end
end
