# frozen_string_literal: true

module DocumentsHelper
  def category_collection(document = nil)
    Document.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: category_scope,
                        construction: document&.construction_type || t("construction_type.home")),
       category_name]
    end
  end

  private

  def category_scope
    "activerecord.attributes.document.categories"
  end
end
