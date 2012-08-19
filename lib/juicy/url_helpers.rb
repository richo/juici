# So this is pretty much just horrific, but at least an interestingish
# proof of concept
# XXX Deprecated
module Juicy
  def self.url_helpers(route)
    Module.new do
      @@route = route

      def url_for(child)
        "/#{@@route}/#{child}"
      end

    end
  end
end
