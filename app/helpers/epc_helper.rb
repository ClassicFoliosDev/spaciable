# frozen_string_literal: true

module EpcHelper
  def epc_collection
    MaterialInfo.epc_ratings.map do |(epc, _int)|
      [t(epc, scope: epc_label_scope), epc]
    end
  end

  private

  def epc_label_scope
    "activerecord.attributes.material_info.epc_labels"
  end
end
