require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Juici build logic" do

  describe "Shebangs" do
    before(:all) do
      testlogic = Class.new
      testlogic.include ::Juici::BuildLogic
      @logic = testlogic.new
    end

    it "Should parse shebang lines" do
      cmd = @logic.send(:parse_cmd, <<-EOS)
#!/bin/cat
#
rawr lols
EOS
      cmd[0].should == "/bin/cat"
      cmd.length.should == 2
    end

    it "Should deal with args to the shebang" do
      cmd = @logic.send(:parse_cmd, <<-EOS)[0]
#!/usr/bin/env csi -ss
#
rawr lols
EOS
      cmd[0].should == "/usr/bin/env"
      cmd[1].should == "csi"
      cmd[2].should == "-ss"
      cmd.length.should == 4
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
