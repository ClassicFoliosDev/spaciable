# frozen_string_literal: true

module SewerageHelper
  def sewerage_collection
    MaterialInfo.sewerages.map do |(sewerage, _int)|
      [t(sewerage, scope: sewerage_label_scope), sewerage]
    end
  end

  private

  def sewerage_label_scope
    "activerecord.attributes.material_info.sewerage_labels"
  end
end
