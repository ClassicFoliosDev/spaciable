# frozen_string_literal: true

class Log < ApplicationRecord
  include RoleEnum
  belongs_to :logable, polymorphic: true
  has_one :mark, as: :markable, dependent: :destroy

  delegate :marker, to: :mark, allow_nil: true

  before_save :make_mark

  enum action: %i[
    created
    added
    updated
    deleted
    removed
  ]

  def make_mark
    self.mark ||= create_mark(username: RequestStore.store[:current_user]&.full_name,
                              role: RequestStore.store[:current_user]&.role)
  end

  class << self
    # Enter a log.
    def log(params)
      Log.new(params).save
    end

    # Retrieve the logs for a particular instance (loggable type/id)
    def logs(instance)
      log_records = Log.where(logable_type: instance.class.to_s, logable_id: instance.id)
      return log_records if instance.log_threshold == :none
      log_records.where("created_at > ?", instance.log_threshold)
    end
  end
end
