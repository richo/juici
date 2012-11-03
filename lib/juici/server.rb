require 'sinatra/base'
require 'net/http' # for URI#escape

module Juici
  class Server < Sinatra::Base

    @@juici = nil

    def juici
      @@juici
    end

    helpers do
      include Ansible

      Dir[File.dirname(__FILE__) + "/helpers/**/*.rb"].each  do |file|
        load file
      end
    end

    dir = File.dirname(File.expand_path(__FILE__))

    def self.start(host, port)
        @@juici = App.new
        Juici::Server.run!(:host => host, :port => port) do |server|
          [:INT, :TERM].each do |sig|
            trap(sig) do
              $stderr.puts "Shutting down JuiCI"
              App.shutdown
              server.respond_to?(:stop!) ? server.stop! : server.stop
            end
          end
        end
    end

    def self.rack_start(project_path)
      self.new
    end

    set :views,  "#{dir}/views"
    set :public_folder, "public"
    set :static, true

    get '/' do
      Controllers::Index.new.index do |template, opts|
        erb(template, {}, opts)
      end
    end

    get '/about' do
      Controllers::Index.new.about do |template, opts|
        erb(template, {}, opts)
      end
    end

    get '/builds' do
      Controllers::Index.new.builds do |template, opts|
        erb(template, {}, opts)
      end
    end

    get '/support' do
      Controllers::Index.new.support do |template, opts|
        erb(template, {}, opts)
      end
    end

    POST_BUILDS_NEW = Proc.new do
      build = Controllers::Trigger.new(params[:project], params).build!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end
    post('/builds/new', &POST_BUILDS_NEW)

    POST_BUILDS_REBUILD = Proc.new do
      build = Controllers::Trigger.new(params[:project], params).rebuild!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end
    post('/builds/:project/rebuild/:id', &POST_BUILDS_REBUILD)
    post('/builds/:_user/:_project/rebuild/:id', &POST_BUILDS_REBUILD)

    POST_BUILDS_KILL = Proc.new do
      build = Controllers::Builds.new(params).kill
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end
    post('/builds/kill', &POST_BUILDS_KILL)

    GET_BUILDS_NEW = Proc.new do
      Controllers::Builds.new(params).new do |template, opts|
        erb(template, {}, opts)
      end
    end
    get('/builds/new', &GET_BUILDS_NEW)

    GET_BUILDS_LIST = Proc.new do
      Controllers::Builds.new(params).list do |template, opts|
        erb(template, {}, opts)
      end
    end
    get('/builds/:project/list', &GET_BUILDS_LIST)
    get('/builds/:_user/:_project/list', &GET_BUILDS_LIST)

    get '/builds/:project/edit/:id' do
      Controllers::Builds.new(params).edit do |template, opts|
        erb(template, {}, opts)
      end
    end

    get '/builds/:user/:project/edit/:id' do
      params[:project] = "#{params[:user]}/#{params[:project]}"
      Controllers::Builds.new(params).edit do |template, opts|
        erb(template, {}, opts)
      end
    end

    post '/builds/:project/edit/:id' do
      build = Controllers::Builds.new(params).update!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    post '/builds/:user/:project/edit/:id' do
      params[:project] = "#{params[:user]}/#{params[:project]}"
      build = Controllers::Builds.new(params).update!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    GET_BUILDS_SHOW = Proc.new do
      Controllers::Builds.new(params).show do |template, opts|
        erb(template, {}, opts)
      end
    end
    get('/builds/:project/show/:id', &GET_BUILDS_SHOW)
    get('/builds/:_user/:_project/show/:id', &GET_BUILDS_SHOW)

    POST_TRIGGER_PROJECT = Proc.new do
      Controllers::Trigger.new(params[:project], params).build!
    end
    post('/trigger/:project', &POST_TRIGGER_PROJECT)

    get '/queue' do
      Controllers::BuildQueue.new(params).list do |template, opts|
        erb(template, {}, opts)
      end
    end

    not_found do
      erb(:not_found, {}, {})
    end

  end
end
