require 'json'
# status enum
#   :waiting
#   :started
#   :failed
#   :success
#
#   ???
#   :profit!
#
module Juici
  class Build
    # A wrapper around the build process

    include Mongoid::Document
    include ::Juici.url_helpers("builds")
    include BuildLogic
    # TODO Builds should probably be children of projects in the URL?

    # Finder classmethods
    def self.get_recent(n, opts={})
      self.where(opts).
        limit(n).
        desc(:_id)
    end

    field :parent, type: String
    field :command, type: String
    field :environment, type: Hash
    field :create_time, type: Time, :default => Proc.new { Time.now }
    field :start_time, type: Time, :default => nil
    field :end_time, type: Time, :default => nil
    field :status, type: Symbol, :default => :waiting
    field :priority, type: Fixnum, :default => 1
    field :pid, type: Fixnum
    field :buffer, type: String
    field :warnings, type: Array, :default => []
    field :callbacks, type: Array, :default => []
    field :title, type: String, :default => Proc.new { Time.now.to_s }

    def set_status(value)
      self[:status] = value
      save!
    end

    def start!
      self[:start_time] = Time.now
      set_status :started
    end

    def success!
      finish
      set_status :success
      process_callbacks
    end

    def failure!
      finish
      set_status :failed
      process_callbacks
    end

    def finish
      self[:end_time] = Time.now
      self[:output] = get_output
      $build_queue.purge(:pid, self) if $build_queue
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
      when :waiting
        "build-heading-pending"
      when :failed
        "build-heading-failed"
      when :success
        "build-heading-success"
      when :started
        "build-heading-started"
      end
    end

    def get_output
      return "" unless self[:buffer]
      File.open(self[:buffer], 'r') do |f|
        f.rewind
        f.read
      end
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
        Callback.new(self, callback_url).process!
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
    end

  end
end
