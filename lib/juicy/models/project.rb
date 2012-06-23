module Juicy
  class Project
    include Mongoid::Document
    include Juicy.url_helpers("projects")

    field :name, type: String

  end
end
