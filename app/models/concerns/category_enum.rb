# frozen_string_literal: true

module CategoryEnum
  extend ActiveSupport::Concern

  included do
    enum category: %i[
      my_home
      locality
      legal_and_warranty
    ]
  end
end
