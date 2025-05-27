# frozen_string_literal: true

module CouncilTaxBandHelper
  def council_tax_band_collection
    MaterialInfo.council_tax_bands.map do |(band, _int)|
      [t_council_tax_band(band), band]
    end
  end

  def t_council_tax_band(band)
    t(band, scope: band_label_scope)
  end

  private

  def band_label_scope
    "activerecord.attributes.material_info.council_tax_band_labels"
  end
end
