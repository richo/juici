require 'sinatra/base'

module Juicy
  class Server < Sinatra::Base

    helpers do
      Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each  do |file|
        load file
      end
    end

    attr_reader :juicy

    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public_folder, "#{dir}/public"
    set :static, true
    set :lock, true

    def initialize(*args)
      @juicy = Juicy::App.new
      super(*args)
    end

    def self.start(host, port)
      Juicy::Server.run! :host => host, :port => port
    end

    def self.rack_start(project_path)
      self.new
    end

    get '/' do
      erb(:index, {}, :juicy => juicy)
    end

    get '/projects' do
      erb(:projects, {}, :juicy => juicy)
    end

    get '/builds/:project' do
      erb(:builds, {}, :juicy => juicy, :project => params[:project])
    end

    post '/trigger/:project' do
      TriggerController.new(params[:project], params).build!
    end

  end
end
