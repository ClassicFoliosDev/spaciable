# frozen_string_literal: true

module BroadbandHelper
  def broadband_collection
    MaterialInfo.broadbands.map do |(supply, _int)|
      [t_broadband(supply), supply]
    end
  end

  def t_broadband(supply)
    t(supply, scope: broadband_label_scope)
  end

  private

  def broadband_label_scope
    "activerecord.attributes.material_info.broadband_labels"
  end
end
