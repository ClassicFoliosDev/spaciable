# frozen_string_literal: true

class FaqTypeCategory < ApplicationRecord
  belongs_to :faq_type
  belongs_to :faq_category

  delegate :name, to: :faq_category, prefix: :category
  delegate :name, to: :faq_type, prefix: :type

  scope :of_type,
        lambda { |type|
          where(faq_type: type).order(:id)
        }

  scope :category_ids,
        lambda { |type|
          where(faq_type: type).order(:id).pluck(:faq_category_id)
        }

  def self.categories(type)
    FaqCategory.where(id: FaqTypeCategory.category_ids(type))
  end
end
