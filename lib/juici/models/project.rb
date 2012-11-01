module Juici
  class Project
    include Mongoid::Document

    field :name, type: String

  end
end
