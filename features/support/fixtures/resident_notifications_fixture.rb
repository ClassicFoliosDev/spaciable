# frozen_string_literal: true

require_relative "create_fixture"

module ResidentNotificationsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  MESSAGES = {
    all: {
      subject: "New Features released!",
      message: "Homeowners can now build a 3D model of their home..."
    },
    developer: {
      subject: "Happy new year",
      message: "Reminder of annual checks to do..."
    },
    division: {
      subject: "Merry christmas",
      message: "To celebrate the season..."
    },
    development: {
      subject: "Ice warning",
      message: "Be wary on the ramps leading up to..."
    },
    division_development: {
      subject: "Parking reminder",
      message: "Cars parked along the road will be towed..."
    },
    phase: {
      subject: "Boiler recall",
      message: "The Bosch washing machines fitted..."
    },
    division_phase: {
      subject: "Reminder for",
      message: "Bonfires are not allowed on the premises!"
    },
    developer_plot: {
      subject: "You are being evicted",
      message: "Only joking! We need to replace your boiler."
    },
    division_plot: {
      subject: "We are dividing your plot into two",
      message: "To offer you a better habitat abstraction."
    },
    development_plot: {
      subject: "How To Read How Tos",
      message: "Firstly, grab a spoon and a hammer..."
    },
    phase_plot: {
      subject: "When you hit *that* phase in your development",
      message: "The concrete is in, the timber has been put up...."
    }
  }.freeze

  def create_permission_resources
    create_developer
    create_division
    create_development
    create_division_development
    create_phases
    create_unit_type
    create_phase_plot
    create_division_development_plot
    create_notification_residents
  end

  def create_spanish_permission_resources
    create_spanish_developer
    create_spanish_division
    create_spanish_development
    create_spanish_division_development
    create_spanish_phases
    create_spanish_unit_type
    create_spanish_phase_plot
    create_spanish_division_development_plot
    create_notification_residents
  end

  def developer_plot
    development_plot
  end

  def resident_email_addresses(under: instance)
    under.residents.where(developer_email_updates: true).map(&:email).uniq
  end

  def extract_resource(parent, resource_class)
    resource_class.downcase!
    resource = resource_class.to_sym

    parent_class = parent.gsub(/\W/, "").downcase if parent
    resource = :"#{parent_class}_#{resource}" if parent_class.present?

    # [type, instance]
    [resource, send(resource)]
  end
end
