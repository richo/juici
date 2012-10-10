module Juici::Controllers
  class Index

    def index
      yield [:index,  {}]
    end

  end
end

