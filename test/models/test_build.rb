require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestJuiciModelsBuild < Test::Unit::TestCase
  def test_has_total_duration_if_complete
    build = Juici::Build.new
    Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5005))
    build.start!
    build.success!

    assert_equal(build.time_elapsed.to_i, 5)
  end

  def test_has_time_running_if_started
    build = Juici::Build.new
    Time.stubs(:now).returns(Time.at(5000)).then.returns(Time.at(5006))
    build.start!

    assert_equal(build.time_elapsed.to_i, 6)
  end

  def test_time_elapsed_is_nil_if_not_started
    build = Juici::Build.new
    assert_nil(build.time_elapsed)
  end
end
