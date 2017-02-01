# frozen_string_literal: true
class Faq < ApplicationRecord
  enum category: [:general, :settling, :troubleshooting, :urgent, :your_home]

  belongs_to :faqable, polymorphic: true

  validates :question, :answer, :category, :faqable, presence: true

  delegate :to_s, to: :question
end
