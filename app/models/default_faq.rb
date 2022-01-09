# frozen_string_literal: true

class DefaultFaq < ApplicationRecord
  include FaqPackageEnum

  acts_as_paranoid

  belongs_to :country
  belongs_to :faq_type
  belongs_to :faq_category

  validates :question, :answer, :category, :faq_type, :faq_category, :faq_package, presence: true
  delegate :to_s, to: :question

  delegate :name, to: :faq_type, prefix: :type
  delegate :name, to: :faq_category, prefix: :category
  delegate :categories, to: :faq_type

  scope :of_type,
        lambda { |type|
          where(faq_type: type)
        }
end
