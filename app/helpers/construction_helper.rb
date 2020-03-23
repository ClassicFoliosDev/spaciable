# frozen_string_literal: true

module ConstructionHelper
  def construction_collection
    Development.constructions.map do |(construction_label, _construction_label_int)|
      [t(construction_label, scope: construction_label_scope), construction_label]
    end
  end

  private

  def construction_label_scope
    "activerecord.attributes.development.construction_labels"
  end
end
