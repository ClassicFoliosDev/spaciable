# frozen_string_literal: true

# TaskShortcut records the on/off for a shortcut
# against a task
class TaskShortcut < ApplicationRecord
  include ShortcutTypeEnum
  self.table_name = "task_shortcuts"

  belongs_to :task
  belongs_to :shortcut

  delegate :shortcut_type, to: :shortcut
  delegate :id, to: :shortcut, prefix: true
end
