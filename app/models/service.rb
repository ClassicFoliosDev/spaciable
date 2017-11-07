# frozen_string_literal: true

class Service < ApplicationRecord
  acts_as_paranoid

  has_many :resident_services, dependent: :delete_all
  has_many :residents, through: :resident_services

  validates :name, presence: true, uniqueness: true
end
