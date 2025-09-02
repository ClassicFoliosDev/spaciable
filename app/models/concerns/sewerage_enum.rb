# frozen_string_literal: true

module SewerageEnum
  extend ActiveSupport::Concern

  included do
    enum sewerage:
    %i[
      sewerage_unassigned
      mains_sewerage
      septic_tank
      sewage_treatment_plant
      cesspit_cesspool
      sewerage_other
    ]
  end
end
