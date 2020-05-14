# frozen_string_literal: true

# Shortcuts to the specified sections of spaciable.  Each Timeline_Task
# can be associated with a number of these
class Shortcut < ApplicationRecord
  include ShortcutTypeEnum

  # Get the list of shortcuts
  def self.list
    Shortcut.all.order(:id)
  end
end
