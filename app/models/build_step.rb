# frozen_string_literal: true

class BuildStep < ApplicationRecord
  belongs_to :build_sequence
end
