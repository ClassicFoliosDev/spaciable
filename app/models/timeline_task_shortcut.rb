# frozen_string_literal: true

# TimelineTaskShortcut records the on/off for a shortcut
# against a timeline task
class TimelineTaskShortcut < ApplicationRecord
  include ShortcutTypeEnum
  self.table_name = "timeline_task_shortcuts"

  belongs_to :timeline_task
end
