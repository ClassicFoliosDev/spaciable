# frozen_string_literal: true

module CouncilTaxBandEnum
  extend ActiveSupport::Concern

  included do
    enum council_tax_band: 
    %i[
      unavailable
      a
      b
      c
      d
      e
      f
      g
    ]
  end
end
