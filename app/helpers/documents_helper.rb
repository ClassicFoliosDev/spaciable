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

  def guide_selector_valid?(document)
    document.parent.is_a?(Plot) || document.parent.is_a?(Phase) || document.parent.is_a?(Development)
  end

  def manual_exists(document)
    return unless guide_selector_valid?(document)

    documents = gather_documents(document)

    disabled = []
    if documents.size.positive?
      documents.flatten!.each do |document|
        disabled << document.guide if document.guide
        # guide has two potential values (reservation, completion)
        # stop checking documents if both values are present in disabled array
        break if disabled.uniq.size == 2
      end
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

  def gather_documents(document)
    documents = []

    # parent documents
    parent = document.parent
    while parent do
      documents << parent.documents
      parent = parent.parent
      break if (parent.is_a? Developer) || (parent.is_a? Division)
    end

    # child documents
    # the highest starting level is development
    # therefore we need to check two generations at most to reach plot level
    unless document.parent.is_a?(Plot)
      children = document.parent.children

      # first generation
      children.each do |child|
        documents << child.documents
        # second generation
        if child.children
          child.children.each do |cchild|
            documents << cchild.documents
          end
        end
      end
    end

    documents
  end
end
