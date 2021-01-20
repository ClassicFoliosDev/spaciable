# frozen_string_literal: true

module StageSetTypeEnum
  extend ActiveSupport::Concern

  included do
    enum stage_set_type: %i[
      custom
      uk
      scotland
      proforma
    ]
  end

  def self.default_stage_sets
    stage_set_types
  end
end
