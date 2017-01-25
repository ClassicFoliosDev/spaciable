# frozen_string_literal: true
require_relative "create_fixture"

module ResidentNotificationsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  MESSAGES = {
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
    }
  }.freeze

  def create_permission_resources
    create_developer
    create_division
    create_development
    create_division_development
    create_phases
    create_plots
    create_residents
  end

  def resident_email_addresses(under: instance)
    under.residents.map(&:email)
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
