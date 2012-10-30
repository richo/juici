require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestJuiciEnvironment < Test::Unit::TestCase

  def test_sanitises_environment
    new_env = ENV.to_hash
    ::Juici::BUILD_SENSITIVE_VARIABLES.each do |var|
      new_env[var] = "Some values!"
    end
    ENV.stubs(:to_hash).returns(new_env)

    env = ::Juici::BuildEnvironment.new
    ::Juici::BUILD_SENSITIVE_VARIABLES.each do |var|
      assert_nil(env[var])
    end
  end

  def test_merges_json_hashes
    env = ::Juici::BuildEnvironment.new
    json = %[{"my_spec_key": "my_spec_value"}]

    assert_true(env.load_json!(json))
    assert_equal(env["my_spec_key"], "my_spec_value")
  end

  def test_fails_on_json_string
    env = ::Juici::BuildEnvironment.new
    json = %["rawr!"]

    assert_false(env.load_json!(json))
  end

  def test_fails_on_json_integer
    env = ::Juici::BuildEnvironment.new
    json = %[4]

    assert_false(env.load_json!(json))
  end

  def test_fails_on_invalid_json
    env = ::Juici::BuildEnvironment.new
    json = %[{ butts lol]

    assert_false(env.load_json!(json))
  end

  def test_treats_empty_strings_as_valid
    env = ::Juici::BuildEnvironment.new
    json = ""
    assert_true(env.load_json!(json))
  end
end
