# frozen_string_literal: true

class FaqType < ApplicationRecord
  belongs_to :construction_type
  belongs_to :country

  validates :name, presence: true, uniqueness: { scope: :country_id }
  validates :default_type, presence: true, uniqueness: { scope: :country_id }, if: :default_true?

  def default_true?
    default_type == true
  end

  # Get the default FaqType for the country
  scope :default,
        lambda { |country|
          find_by(country: country, default_type: true)
        }

  # Get the FaqTypes for the country
  scope :for_country,
        lambda { |country|
          where(country: country).order(:id)
        }

  def categories
    FaqTypeCategory.categories(self)
  end
end
