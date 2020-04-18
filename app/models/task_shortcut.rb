# frozen_string_literal: true

# A Task has many Shortcuts
# A Shortcut can appear on many Tasks
class TaskShortcut < ApplicationRecord
  self.table_name = "task_shortcuts"

  belongs_to :task
  belongs_to :shortcut
end
