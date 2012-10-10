module Juici::Controllers
  class Index

    def index
      yield [:index,  {}]
    end

    def builds
      yield [:builds, {}]
    end

    def about
      yield [:about, {}]
    end

    def support
      yield [:support, {}]
    end

  end
end

