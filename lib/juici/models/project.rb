module Juici
  class Project
    include Mongoid::Document
    extend FindLogic

    field :name, type: String

  end
end
