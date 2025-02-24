# frozen_string_literal: true

module PropertyConstructionEnum
  extend ActiveSupport::Concern

  included do
    enum property_construction:
    %i[
      traditional
      timber_frame
      modular_build
      plot_construction_other
    ]
  end
end
