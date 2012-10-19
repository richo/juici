module Juici::Controllers
  class Index

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def index
      yield [:index,  {:active => :index, :the_90s => params.include?("90s")}]
    end

    def about
      content = GitHub::Markdown.render(File.read("lib/juici/views/README.markdown"))
      content.gsub!(/<h(\d+)>/, '<h\1 class="block-header">')
      yield [:about, {:active => :about, :content => content}]
    end

    def support
      yield [:support, {:active => :support}]
    end

  end
end
