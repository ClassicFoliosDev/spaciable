# frozen_string_literal: true

class FaqCategory < ApplicationRecord
  scope :of_type,
        lambda { |type|
          joins(faq_type_category: :faq_type).where(faq_types: { id: type.id })
        }
end
