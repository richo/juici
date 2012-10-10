module Juici::Controllers
  class Index

    def index
      yield [:index,  {:active => :index}]
    end

    def about
      yield [:about, {:active => :about}]
    end

    def support
      yield [:support, {:active => :support}]
    end

  end
end

