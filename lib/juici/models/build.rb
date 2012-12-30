require 'json'

module Juici
  class Build
    # A wrapper around the build process

    include Mongoid::Document
    include BuildLogic
    include BuildStatus
    extend FindLogic
    # TODO Builds should probably be children of projects in the URL?

    CLONABLE_FIELDS = [:command, :priority, :environment, :callbacks, :title, :parent]
    EDITABLE_ATTRIBUTES = {
      :string => [:priority, :title],
      :array  => [:environment, :callbacks]
    }

    def self.new_from(other)
      new.tap do |b|
        CLONABLE_FIELDS.each do |prop|
          b[prop] = other[prop]
        end
      end
    end

    field :parent, type: String
    field :command, type: String
    field :environment, type: Hash
    field :create_time, type: Time, :default => Proc.new { Time.now }
    field :start_time, type: Time, :default => nil
    field :end_time, type: Time, :default => nil
    field :status, type: Symbol, :default => WAIT.to_sym
    field :priority, type: Fixnum, :default => 1
    field :pid, type: Fixnum
    field :buffer, type: String
    field :warnings, type: Array, :default => []
    field :callbacks, type: Array, :default => []
    field :title, type: String, :default => Proc.new { Time.now.to_s }

    def set_status(value)
      self.status= value
      save!
    end

    def start!
      self[:start_time] = Time.now
      set_status START
    end

    def success!
      finish
      set_status PASS
      process_callbacks
    end

    def failure!
      finish
      set_status FAIL
      process_callbacks
    end

    def finish
      self[:end_time] = Time.now
      self[:output] = get_output
      $build_queue.purge(:pid, self) if $build_queue
    end

    def cancel
      warn! "Cancelled"
      set_status FAIL
      $build_queue.delete(self[:_id]) if $build_queue
    end

    def build!
      start!
      case pid = spawn_build
      when Fixnum
        Juici.dbgp "#{pid} away!"
        self[:pid] = pid
        self[:buffer] = @buffer.path
        save!
        return pid
      when :enoent
        warn! "No such command"
        failure!
      when :invalidcommand
        warn! "Invalid command"
        failure!
      end
      nil
    end

    def worktree
      File.join(Config.workspace, parent)
    rescue TypeError => e
      warn! "Invalid workdir"
      failure!
      raise AbortBuild
    end

    # View helpers
    def heading_color
      case status
      when WAIT
        "build-heading-pending"
      when FAIL
        "build-heading-failed"
      when PASS
        "build-heading-success"
      when START
        "build-heading-started"
      end
    end

    def get_output
      return "" unless self[:buffer]
      File.open(self[:buffer], 'r') do |f|
        f.rewind
        f.read
      end
    rescue Errno::ENOENT
      ""
    end

    def display_title
      # Catch old builds which didn't have a title
      self[:title] || self[:create_time]
    end

    def link_title
      "#{self[:parent]}/#{display_title}"
    end

    def warn!(msg)
      warnings << msg
      save!
    end

    def process_callbacks
      callbacks.each do |callback_url|
        c = Callback.new(callback_url)
        c.payload = self.to_callback_json
        c.process!
      end
    end


    def to_callback_json
      {
        "project" => self[:parent],
        "status" => self[:status],
        "url" => build_url_for(self),
        "time" => time_elapsed
      }.to_json
    end

    def callbacks
      self[:callbacks] || []
    end

    def time_elapsed
      if self[:end_time]
        self[:end_time] - self[:start_time]
      elsif self[:start_time]
        Time.now - self[:start_time]
      else
        nil
      end
    rescue
      -1 # Throw an obviously impossible build time.
         # This will only occur as a result of old builds.
    end

    # Use symbols internally
    def status
      self[:status].to_s
    end

    def status=(s)
      self[:status] = s.to_sym
    end

    def environment
      self[:environment].tap do |env|
        if env && env.include?("PWD")
          env["PWD"] = worktree
        end
      end
    end
  end
end
