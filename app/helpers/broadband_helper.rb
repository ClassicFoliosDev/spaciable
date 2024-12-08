# frozen_string_literal: true

module BroadbandHelper
  def broadband_collection
    MaterialInfo.broadbands.map do |(supply, _int)|
      [t(supply, scope: broadband_label_scope), supply]
    end
  end

  private

  def broadband_label_scope
    "activerecord.attributes.material_info.broadband_labels"
  end
end
