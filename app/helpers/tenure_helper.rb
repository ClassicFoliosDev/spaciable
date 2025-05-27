# frozen_string_literal: true

module TenureHelper
  def client_tenure_collection
    MaterialInfo.tenures.map do |(tenure, _int)|
      [t_tenure(tenure), tenure]
    end
  end

  def t_tenure(tenure)
    t(tenure, scope: tenure_label_scope)
  end

  private

  def tenure_label_scope
    "activerecord.attributes.material_info.tenure_labels"
  end
end
