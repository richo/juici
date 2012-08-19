require 'sinatra/base'
require 'net/http' # for URI#escape

module Juicy
  class Server < Sinatra::Base

    @@juicy = nil

    def juicy
      @@juicy
    end

    helpers do
      Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each  do |file|
        load file
      end
    end

    dir = File.dirname(File.expand_path(__FILE__))

    def self.start(host, port)
      @@juicy = App.new
      Juicy::Server.run! :host => host, :port => port
    end

    def self.rack_start(project_path)
      self.new
    end

    set :views,  "#{dir}/views"
    set :public_folder, "public"
    set :static, true

    get '/' do
      @page = :index
      erb(:index, {}, :juicy => juicy)
    end

    get '/about' do
      erb(:about)
    end

    get '/builds' do
      @page = :builds
      @action = :list
      erb(:builds, {}, :juicy => juicy)
    end

    get '/builds/new' do
      @page = :builds
      @action = :new
      erb(:"builds/new", :juicy => juicy)
    end

    post '/builds/new' do
      TriggerController.new(params[:project], params).build!
      @redirect_to = build_url_for(params[:project])
      erb(:redirect, {}, :juicy => juicy)
    end

    get '/builds/:project' do
      @page = :builds
      @action = :show
      erb(:"builds/show", {}, :juicy => juicy, :project => params[:project])
    end

    post '/trigger/:project' do
      TriggerController.new(params[:project], params).build!
    end

  end
end