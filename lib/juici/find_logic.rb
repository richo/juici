module Juici
  module FindLogic

    def find_or_raise(exc, by)
      self.where(by).first.tap do |rec|
        raise exc if rec.nil?
      end
    end

    def get_recent(n, opts={})
      self.where(opts).
        limit(n).
        desc(:_id)
    end

  end
end
