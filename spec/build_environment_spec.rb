require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Stub the shit out of ENV.to_hash
describe "Juici build environment" do

  it "Should hose sensitive environment variables" do
    new_env = ENV.to_hash
    ::Juici::BUILD_SENSITIVE_VARIABLES.each do |var|
      new_env[var] = "Some values!"
    end
    ENV.stubs(:to_hash).returns(new_env)

    env = ::Juici::BuildEnvironment.new
    ::Juici::BUILD_SENSITIVE_VARIABLES.each do |var|
      env[var].should be_nil
    end
  end

  it "Should merge json hashes" do
    env = ::Juici::BuildEnvironment.new
    json = %[{"my_spec_key": "my_spec_value"}]

    env.load_json!(json).should == true
    env["my_spec_key"].should == "my_spec_value"
  end

  it "Should fail on valid json that is a string" do
    env = ::Juici::BuildEnvironment.new
    json = %["rawr!"]

    env.load_json!(json).should == false
  end

  it "Should fail on valid json that is an integer" do
    env = ::Juici::BuildEnvironment.new
    json = %[4]

    env.load_json!(json).should == false
  end

  it "Should fail on invalid json" do
    env = ::Juici::BuildEnvironment.new
    json = %[{ butts lol]

    env.load_json!(json).should == false
  end

  it "Should regard an empty string as valid" do
    env = ::Juici::BuildEnvironment.new
    json = ""
    env.load_json!(json).should == true
  end

  it "Should return the desired environment on #to_hash" do
    env = ::Juici::BuildEnvironment.new
    env.load_hash!({"key" => nil})

    env.to_hash.include?("key").should be_false
  end

  it "Should return nil keys for values to be erased on #to_environment" do
    env = ::Juici::BuildEnvironment.new
    env.load_hash!({"key" => nil})

    env.to_environment["key"].should be_nil
  end

end
