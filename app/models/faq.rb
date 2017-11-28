# frozen_string_literal: true

class Faq < ApplicationRecord
  belongs_to :faqable, polymorphic: true

  attr_accessor :notify

  alias parent faqable

  enum category: %i[settling home troubleshooting urgent general]

  validates :question, :answer, :category, :faqable, presence: true

  delegate :to_s, to: :question
end
