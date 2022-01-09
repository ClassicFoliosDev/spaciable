# frozen_string_literal: true

class BuildStep < ApplicationRecord
  belongs_to :build_sequence
  delegate :build_sequenceable_type, to: :build_sequence
  alias_attribute :identity, :title
end
