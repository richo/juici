require 'sinatra/base'
require 'net/http' # for URI#escape

module Juici
  class Server < Sinatra::Base

    extend Router
    include Router

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

    post build_new_path do
      build = Controllers::Trigger.new(params[:project], params).build!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    post build_rebuild_path do |project, id|
      params[:project] = project
      params[:id] = id
      build = Controllers::Trigger.new(project, params).rebuild!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    post '/builds/kill' do
      build = Controllers::Builds.new(params).kill
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    post '/builds/cancel' do
      build = Controllers::Builds.new(params).cancel
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    get ::Juici::Routes::NEW_BUILD do
      Controllers::Builds.new(params).new do |template, opts|
        erb(template, {}, opts)
      end
    end

    get build_list_path do |project|
      params[:project] = project
      Controllers::Builds.new(params).list do |template, opts|
        erb(template, {}, opts)
      end
    end

    get build_edit_path do |project, id|
      Controllers::Builds.new(params).edit do |template, opts|
        erb(template, {}, opts)
      end
    end

    post build_edit_path do |project, id|
      build = Controllers::Builds.new(params).update!
      @redirect_to = build_url_for(build)
      erb(:redirect, {}, {})
    end

    get build_show_path do |project, id|
      Controllers::Builds.new(params).show do |template, opts|
        erb(template, {}, opts)
      end
    end

    post build_trigger_path do |project, id|
      Controllers::Trigger.new(params[:project], params).build!
    end

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
