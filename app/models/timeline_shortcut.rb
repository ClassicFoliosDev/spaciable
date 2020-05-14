# frozen_string_literal: true

# A Timeline has many Shortcuts
# A Shortcut can appear on many Timelines
class TimelineShortcut < ApplicationRecord
  self.table_name = "timeline_shortcuts"

  belongs_to :timeline
  belongs_to :shortcut

  delegate :shortcut_type, to: :shortcut
  delegate :link, to: :shortcut
end
