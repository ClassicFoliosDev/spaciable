# frozen_string_literal: true

class FinishManufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer, dependent: :destroy
  has_many :finish_categories, through: :finish_types
  belongs_to :developer, optional: true

  scope :with_type,
        lambda { |type|
          joins(:finish_types)
            .where(finish_types: { id: type })
            .order(:name)
        }

  validates :finish_types, length: { minimum: 1 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  delegate :to_s, to: :name

  def self.find_or_create(name, developer, type)
    return nil if name.blank?
    man = FinishManufacturer.find_or_initialize_by(name: name, developer_id: developer)
    man.finish_type_ids |= [type.id] # add if unique
    man.save!
    man
  end
end
