# frozen_string_literal: true

module PropertyConstructionEnum
  extend ActiveSupport::Concern

  included do
    enum property_construction:
    %i[
      property_construction_unassigned
      traditional
      timber_frame
      modular_build
      plot_construction_other
    ]
  end
end
