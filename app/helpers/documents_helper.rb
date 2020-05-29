# frozen_string_literal: true

module DocumentsHelper
  def category_collection(document)
    Document.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: "activerecord.attributes.document.categories",
                        construction: document.construction_type), category_name]
    end
  end

  def guide_collection(_document)
    Document.guides.map do |(guide_name, _guide_int)|
      [t(guide_name, scope: "activerecord.attributes.document.guides"), guide_name]
    end
  end

  def guide_selector_valid?(document)
    document.parent.is_a?(Plot) || document.parent.is_a?(Phase) ||
      document.parent.is_a?(Development)
  end

  def manual_exists(document)
    return unless guide_selector_valid?(document)

    documents = gather_documents(document)

    disabled = []
    if documents.size.positive?
      documents.flatten!.each do |doc|
        disabled << doc.guide if doc.guide
        # guide has two potential values (reservation, completion)
        # stop checking documents if both values are present in disabled array
        break if disabled.uniq.size == 2
      end
    end
    disabled
  end

  private

  def gather_documents(document)
    documents = []

    # parent documents
    parent = document.parent
    while parent && ![Developer, Division].member?(parent.class)
      documents << parent.documents
      parent = parent.parent
    end

    # gather documents for all descendants under the parent
    # e.g. if parent is a development, descendants will be all phases under the development,
    # and all plots under each of the phases
    unless document.parent.is_a?(Plot)
      descendants = document.parent.descendants

      descendants.each do |descendant|
        documents << descendant.documents
      end
    end

    documents
  end
end
