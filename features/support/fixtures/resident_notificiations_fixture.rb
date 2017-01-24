# frozen_string_literal: true
require_relative "create_user_fixtures"

module ResidentNotificationsFixture
  include CreateUserFixtures
  # Methods from CreateUserFixtures
  %I[
    create_developer_admin
    create_division_admin
    create_development_admin
    create_division_development_admin

    create_developer
    create_division
    create_development
    create_division_development

    developer_name
    division_name
    development_name
    division_development_name

    developer
    division
    development
    division_development
  ].map { |method| module_function method }

  module_function

  def create_permission_resources
    create_developer
    create_division
    create_development
    create_division_development
    create_phase
    create_plots
    create_residents
  end

  def developer_admin_messages
    {
      to_all: {
        subject: "Welcome #{developer} Residents",
        message: "Happy New Year!", developer: developer,
        recipient_level: developer
      }
    }
  end

  def division_admin_messages
    {
      to_all: {
        subject: "Welcome #{division} Residents",
        message: "Merry Christmas!", division: division,
        recipient_level: division
      }
    }
  end

  def phase
    Phase.find_by(name: phase_name)
  end

  def phase_name
    "Alpine"
  end

  def create_phase
    FactoryGirl.create(:phase, name: phase_name)
  end

  def create_plots
    FactoryGirl.create(:plot, development: development)
    FactoryGirl.create(:plot, development: division_development)
    FactoryGirl.create(:phase_plot, phase: phase)
  end

  def create_residents
    Plot.all.each do |plot|
      attrs = { first_name: "Resident of", last_name: "plot #{plot}" }
      resident = FactoryGirl.create(:homeowner, attrs)
      resident.plots << plot
    end
  end

  delegate :residents, to: :developer, prefix: true
  module_function :developer_residents

  def recipient_emails
    ActionMailer::Base.deliveries.map(&:to).flatten
  end

  def developer_resident_emails
    developer_residents.map(&:email)
  end
end
