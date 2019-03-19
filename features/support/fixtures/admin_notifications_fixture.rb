# frozen_string_literal: true

require_relative "create_fixture"

module AdminNotificationsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def create_admin_resources
    create_developer
    create_division
    create_developer_admin
    create_division_admin
  end

  MESSAGES = {
    all: {
      subject: "New Features Added to Hoozzi!",
      message: "The following features have been added to Hoozzi..."
    }
  }.freeze

end