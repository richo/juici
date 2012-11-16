module Juici
  module BuildStatus
    PASS = "success"
    FAIL = "failed"
    START = "started"
    WAIT = "waiting"
  end

  module Routes
    NEW_BUILD = '/builds/new'
  end

end
