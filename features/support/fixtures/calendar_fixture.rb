# frozen_string_literal: true

# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module CalendarFixture
  module_function

  NOW = Time.zone.now

  TITLES =
    { today: "Catch Up",
      tomorrow: "Pay up",
      next_week: "Throw up"
    }

  LOCATIONS =
    { zoom: "Zoom",
      erics: "Round at Eric's",#
      starbucks: "Starbucks"
    }

  # Global event details that get updated as the
  # test moves along.  These can be used to retrieve
  # the event and pop up the dialog
  @@event = nil

  MONTHVIEWDAYS = 42

  def self.event=(e)
    @@event = e
  end

  def self.event
    @@event
  end

  def self.timezone
    CreateFixture.phase_plot.time_zone
  end

  def self.now
    NOW.in_time_zone(timezone)
  end

  def self.reproposed_start
    CalendarFixture.event.start + 1.hour
  end

  def self.reproposed_end
    CalendarFixture.event.end + 2.hours
  end

  def self.initialise
    @@event = Event.new(start: NOW,
                      end: NOW + 15.minutes,
                      title: CalendarFixture::TITLES[:today],
                      location: CalendarFixture::LOCATIONS[:zoom],
                      repeat: :never,
                      repeat_until: nil,
                      reminder: :nix)

    Development.find(CreateFixture.development.id).update_column(:calendar, true)
  end

end
# rubocop:enable ModuleLength
