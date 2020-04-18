# frozen_string_literal: true

# Shortcuts to the specified sections of spaciable.  Each Timeline_Task
# can be associated with a number of these
class Shortcut < ApplicationRecord
  enum shortcut_type: %i[
    how_tos
    services
    faqs
    area_guide
  ]
end
