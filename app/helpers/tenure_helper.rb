# frozen_string_literal: true

module TenureHelper
  def client_tenure_collection
    MaterialInfo.tenures.map do |(tenure, _int)|
      [t(tenure, scope: tenure_label_scope), tenure]
    end
  end

  private

  def tenure_label_scope
    "activerecord.attributes.material_info.tenure_labels"
  end
end
