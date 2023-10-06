# frozen_string_literal: true

module Unlatch
  class Section < ApplicationRecord
  	include CategoryEnum

  	self.table_name = "unlatch_sections"

    belongs_to :program, class_name: "Unlatch::Program"
    has_many :documents, class_name: "Unlatch::Document"
    
  end
end
