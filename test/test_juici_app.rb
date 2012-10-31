require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestJuiciApp < Test::Unit::TestCase

  def test_instanciates_cleanly
    app = Juici::App.new
    Juici::App.shutdown
  end

end
