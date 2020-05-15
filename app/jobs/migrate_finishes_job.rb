# frozen_string_literal: true

class MigrateFinishesJob < ApplicationJob
  queue_as :admin

  # This is job runs inside a delayed job and the usual
  # RequestStore.store[:current_user] used to create
  # a Mark that tags operations with usernames is not available.
  # This User class provides the same interface as the
  # main User model class.  It is populated with the
  # username and role to allow model classes to create
  # Marks when they are migrating Finishes and FinishRooms
  class User
    attr_accessor :full_name
    attr_accessor :role

    def initialize(name, role)
      @full_name = name
      @role = role
    end
  end

  def perform(developer, username, role)
    RequestStore.store[:current_user] = User.new(username, role)
    Cas.initialise developer
  end
end
