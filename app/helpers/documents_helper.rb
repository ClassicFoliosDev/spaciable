# frozen_string_literal: true

module DocumentsHelper
  def category_collection(document)
    Document.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: category_scope,
                        construction: document.construction_type), category_name]
    end
  end

  def guide_collection(document)
    Document.guides.map do |(guide_name, _guide_int)|
      [t(guide_name, scope: guide_scope), guide_name]
    end
  end

  def manual_exists(document)
    disabled = []
    documents = []
    parent = document.parent
    while parent do
      documents << parent.documents
      parent = parent.parent
      break if (parent.is_a? Developer) || (parent.is_a? Division)
    end
    documents.flatten!.each do |document|
      disabled << document.guide if document.guide
    end
    disabled
  end

  private

  def category_scope
    "activerecord.attributes.document.categories"
  end

  def guide_scope
    "activerecord.attributes.document.guides"
  end
end
