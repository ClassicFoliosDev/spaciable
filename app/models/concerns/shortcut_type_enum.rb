# frozen_string_literal: true

module ShortcutTypeEnum
  extend ActiveSupport::Concern

  included do
    enum shortcut_type: %i[
      how_tos
      services
      faqs
      area_guide
    ]
  end
end
