module Juici
  class Project
    include Mongoid::Document
    include Juici.url_helpers("builds")

    field :name, type: String

  end
end
