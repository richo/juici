module Juici::Controllers
  class Index

    def index
      yield [:index,  {}]
    end

    def builds
      yield [:builds, {}]
    end

  end
end

