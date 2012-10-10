module Juici
  module Controllers
    class Base

      def build_opts(opts)
        default_opts.merge(opts)
      end

      def default_opts
        {
          :styles => styles
        }
      end

      def styles
        []
      end

    end
  end
end
