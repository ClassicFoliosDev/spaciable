# frozen_string_literal: true

require_relative "named_create_fixture"

module AdminNotificationsFixture
  extend ModuleImporter
  import_module NamedCreateFixture

  module_function

  def create_admin_resources
    create_developer
    create_division
    create_development
    create_developer_admin
    create_division_admin
    create_development_admin

    create_second_developer
    create_second_division
    create_second_division_development
    create_second_developer_admin
    create_second_division_development_admin
  end

  def notification_subject
    "Hello"
  end

  def notification_message
    "This is a test yes good"
  end
end