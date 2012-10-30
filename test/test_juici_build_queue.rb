require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestJuiciBuildQueue < Test::Unit::TestCase

  def new_queue(builds)
    Juici::BuildQueue.new.tap { |q| q.__builds = builds }
  end

  def test_default_priority
    q = new_queue([])
    assert_equal(q.current_min_priority, 1)
  end

  def test_returns_min_priority
    q = new_queue(builds_with(priority: [5, 3, 7]))
    assert_equal(q.current_min_priority, 3)
  end

  def test_deals_gracefully_with_nil
    q = new_queue(builds_with(priority: [5, 4, nil, 7]))
    assert_equal(q.current_min_priority, 4)
  end

  def test_removes_builds_by_pid
    q = new_queue(builds_with(pid: [1, 2, 3, 4, 5, 6]))
    q.purge(:pid, stub(:pid => 3))
    assert_equal(q.builds.collect(&:pid), [1, 2, 4, 5, 6])
  end

  def test_silently_fails_to_remove_nonexistant_builds
    q = new_queue(builds_with(pid: [1, 2, 3, 4, 5, 6]))
    q.purge(:pid, stub(:pid => 1000))
    assert_equal(q.builds.collect(&:pid), [1, 2, 3, 4, 5, 6])
  end

  # def test_removes_builds_by_id
  # end

  def test_next_child_returns_lowest_priority_build
    q = new_queue(builds_with(priority: [1, 2, 3, 4, 5, 6]))
    assert_equal(q.next_child.priority, 1)
    q = new_queue(builds_with(priority: [6, 5, 4, 3, 2, 1]))
    assert_equal(q.next_child.priority, 1)
  end

end

class Juici::BuildQueue #{{{ Test injection
  def __builds=(builds)
    @builds = builds
  end

  def __builds
    @builds
  end
end #}}}

def builds_with(args)
  args.map do |k, v|
    v.map do |i|
      stub(k => i)
    end
  end.flatten
end

