module Juicy
  class Watcher < Thread

    def shutdown!
      # XXX is that the right syntax?
      self.kill
    end
  end
end
