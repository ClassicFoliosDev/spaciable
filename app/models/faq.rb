# frozen_string_literal: true

class Faq < ApplicationRecord
  belongs_to :faqable, polymorphic: true
  belongs_to :faq_type
  belongs_to :faq_category

  delegate :country, to: :faqable

  attr_accessor :notify
  alias parent faqable

  validates :question, :answer, :faq_type, :faq_category, :faqable, presence: true

  delegate :to_s, to: :question
  delegate :name, to: :faq_type, prefix: :type
  delegate :name, to: :faq_category, prefix: :category
  delegate :categories, to: :faq_type

  scope :visible_to,
        lambda { |user, type|
          accessible_by(user).where(faq_type: type)
        }
end
