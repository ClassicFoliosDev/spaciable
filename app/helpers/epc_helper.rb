# frozen_string_literal: true

module EpcHelper
  def epc_collection
    MaterialInfo.epc_ratings.map do |(epc, _int)|
      [t_epc_rating(epc), epc]
    end
  end

  def t_epc_rating(epc)
    t(epc, scope: epc_label_scope)
  end

  private

  def epc_label_scope
    "activerecord.attributes.material_info.epc_labels"
  end
end
