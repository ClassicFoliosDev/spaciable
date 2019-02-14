# frozen_string_literal: true

class DefaultFaq < ApplicationRecord
  acts_as_paranoid

  belongs_to :country
  validates :question, :answer, :category, presence: true
end
