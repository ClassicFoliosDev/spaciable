# frozen_string_literal: true

module HomeownerNotificationsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def setup
    create_cf_admin
    create_developer
    create_development
    create_unit_type
    create_development_plot
    create_resident
    create_notifications
  end

  def create_resident
    FactoryGirl.create(:resident, :with_residency, plot: development_plot, email: resident_email, ts_and_cs_accepted_at: Time.zone.now)
  end

  def create_second_plot
    plot = FactoryGirl.create(:plot, number: PlotFixture.another_plot_number)
    FactoryGirl.create(:plot_residency, plot_id: plot.id, resident_id: resident.id)
  end

  def resident_email
    "resident@example.com"
  end

  def resident
    Resident.find_by(email: resident_email)
  end

  # rubocop:disable MethodLength
  def create_notifications
    Notifications.each do |attrs|
      plot_numbers = attrs[:plot_numbers]
      notification = FactoryGirl.create(
        :notification,
        subject: attrs[:subject],
        message: attrs[:message],
        sender_id: CreateFixture.cf_admin.id,
        send_to: attrs[:send_to].call,
        send_to_all: false,
        plot_numbers: plot_numbers
      )

      next unless plot_numbers.blank? || plot_numbers.include?("100")
      FactoryGirl.create(
        :resident_notification,
        resident_id: resident.id,
        notification_id: notification.id
      )
    end
  end
  # rubocop:enable MethodLength

  def notification_id
    Notification.find_by(subject: "Sent from admin to all development").id
  end

  Notifications = [
    {
      subject: "Sent from admin to all developer",
      message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      send_to: -> { developer }
    },
    {
      subject: "Sent from admin to all development",
      message: "Mauris pretium euismod arcu, at placerat magna aliquet condimentum.",
      send_to: -> { development }
    },
    {
      subject: "Sent from developer to resident",
      message: "Maecenas dignissim vestibulum euismod.",
      send_to: -> { development },
      plot_numbers: [CreateFixture.plot_name]
    },
    {
      subject: "Sent to another resident",
      message: "Proin pellentesque, augue ut dignissim posuere, erat urna congue eros, eget fermentum risus justo id nibh.",
      send_to: -> { development },
      plot_numbers: ["100.1"]
    }
  ].freeze
end
