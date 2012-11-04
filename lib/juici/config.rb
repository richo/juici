class Juici::Config; class << self
# XXX Temporary implementation to be replaced by a config reader
  def workspace
    "/tmp/juici/workspace"
  end

  def builds_per_page
    10
  end

end; end
