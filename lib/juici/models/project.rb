module Juici
  class Workspace
    include Mongoid::Document
    extend FindLogic

    field :name, type: String

  end
end
