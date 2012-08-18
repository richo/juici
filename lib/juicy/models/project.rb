module Juicy
  class Project
    include Mongoid::Document
    include Juicy.url_helpers("builds")

    field :name, type: String

  end
end
