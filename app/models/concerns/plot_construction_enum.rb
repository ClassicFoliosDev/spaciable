# frozen_string_literal: true

module PlotConstructionEnum
  extend ActiveSupport::Concern

  included do
    enum plot_construction:
    %i[
      traditional,
      timber_frame,
      modular_build,
      plot_construction_other
    ]
  end
end
