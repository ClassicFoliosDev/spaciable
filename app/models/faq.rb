# frozen_string_literal: true

class Faq < ApplicationRecord
  belongs_to :faqable, polymorphic: true
  attr_accessor :notify
  alias parent faqable

  enum category: %i[
    settling
    home
    troubleshooting
    urgent
    general
    ukp1
    ukp2
    ukp3
    ukp4
    ukp5
    purchasing
  ]

  validates :question, :answer, :category, :faqable, presence: true

  delegate :to_s, to: :question

  # Slice out just the categories for the country.  This is used to populate pulldowns and
  # lists in forms
  def self.country_categories(country)
    range = country.uk? ? Array(0..4) : Array(0..4) << 10
    country_categories = []
    categories.each do |name, value|
      country_categories.push(name) if range.include?(value)
    end

    country_categories
  end
end
