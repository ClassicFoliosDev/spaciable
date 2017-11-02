# frozen_string_literal: true

class DefaultFaq < ApplicationRecord
  acts_as_paranoid

  validates :question, :answer, :category, presence: true
end
