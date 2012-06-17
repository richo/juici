# status enum
#   :waiting
#   :started
#   :failed
#   :success
#
#   ???
#   :profit!
#
module Juicy
  class Build
    # A wrapper around the build process

    include Mongoid::Document

    field :parent, type: String
    field :command, type: String
    field :environment, type: Hash
    field :start_time, type: Time, :default => Proc.new { Time.now }
    field :end_time, type: Time, :default => nil
    field :status, type: Symbol, :default => :waiting

    def set_status(value)
      self[:status] = value
      save!
    end

    def start!
      set_status :started
    end

    def success!
      set_status :success
    end

    def failure!
      set_status :failed
    end

    def build!
      if build_in_progress?
        status = :waiting
      else
        BuildThread.new(self).fire!
      end
    end

    def worktree
      File.join(Config.workspace, parent)
    end

  private

    def build_in_progress?
      # XXX stub
      return false
    end

  end
end
