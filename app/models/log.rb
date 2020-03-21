# frozen_string_literal: true

class Log < ApplicationRecord
  include RoleEnum
  belongs_to :logable, polymorphic: true

  enum action: %i[
    created
    added
    updated
    deleted
    removed
  ]

  # Only CF Admins can see CF admin user names, Non CF admins see "CF Admin"
  def display_name
    return "CF Admin" if cf_admin? && !RequestStore.store[:current_user].cf_admin?
    username
  end

  class << self
    # Enter a log. Username and role supplemented if not present
    def log(params)
      params[:username] = RequestStore.store[:current_user]&.full_name unless params[:username]
      params[:role] = RequestStore.store[:current_user]&.role || :cf_admin
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
