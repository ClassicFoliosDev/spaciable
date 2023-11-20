# frozen_string_literal: true

module Unlatch
  class Section < ApplicationRecord
    include CategoryEnum

    self.table_name = "unlatch_sections"

    belongs_to :developer, class_name: "Unlatch::Developer", dependent: :destroy
    has_many :documents, class_name: "Unlatch::Document", dependent: :destroy
  end
end
