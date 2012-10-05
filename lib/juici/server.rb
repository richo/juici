require 'sinatra/base'
require 'net/http' # for URI#escape

module Juici
  class Server < Sinatra::Base

    @@juici = nil

    def juici
      @@juici
    end

    helpers do
      Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each  do |file|
        load file
      end
    end

    dir = File.dirname(File.expand_path(__FILE__))

    def self.start(host, port)
      @@juici = App.new
      Juici::Server.run! :host => host, :port => port
    end

    def self.rack_start(project_path)
      self.new
    end

    set :views,  "#{dir}/views"
    set :public_folder, "public"
    set :static, true

    get '/' do
      @page = :index
      erb(:index, {}, :juici => juici)
    end

    get '/about' do
      erb(:about)
    end

    get '/builds' do
      @page = :builds
      @action = :list
      erb(:builds, {}, :juici => juici)
    end

    get '/builds/new' do
      @page = :builds
      @action = :new
      erb(:"builds/new", :juici => juici)
    end

    post '/builds/new' do
      TriggerController.new(params[:project], params).build!
      @redirect_to = build_url_for(params[:project])
      erb(:redirect, {}, :juici => juici)
    end

    def list_builds(params)
      erb(:"builds/list", {}, :juici => juici, :project => params[:project])
    end

    get '/builds/:project/list' do
      @page = :builds
      @action = :list
      list_builds(params)
    end

    get '/builds/:user/:project/list' do
      @page = :builds
      @action = :list
      params[:project] = "#{params[:user]}/#{params[:project]}"
      list_builds(params)
    end

    def show_build(params)
      erb(:"builds/list", {}, :juici => juici, :project => params[:project], :id => params[:project])
    end

    get '/builds/:project/show/:id' do
      @page = :builds
      @action = :show
      show_build(params)
    end

    get '/builds/:user/:project/show/:id' do
      @page = :builds
      @action = :show
      params[:project] = "#{params[:user]}/#{params[:project]}"
      show_build(params)
    end

    post '/trigger/:project' do
      TriggerController.new(params[:project], params).build!
    end

  end
end
