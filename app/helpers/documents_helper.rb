# frozen_string_literal: true

module DocumentsHelper
  GUIDES = {
    Plot => %w[reservation completion floor_plan],
    Phase => %w[reservation completion],
    Development => %w[reservation completion],
    UnitType => %w[floor_plan]
  }.freeze

  def category_collection(document = nil)
    Document.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: "activerecord.attributes.document.categories",
                        construction: document&.construction_type || t("construction_type.home")),
       category_name]
    end
  end

  def guide_collection(_document, parent)
    guides = Document.guides.map do |(guide_name, _)|
      next unless GUIDES[parent.class].include? guide_name
      [t(guide_name, scope: "activerecord.attributes.document.guides"), guide_name]
    end
    guides.compact
  end

  def guide_selector_valid?(document)
    document.parent.is_a?(Plot) || document.parent.is_a?(Phase) ||
      document.parent.is_a?(Development) || document.parent.is_a?(UnitType)
  end

  def manual_exists(document)
    return unless guide_selector_valid?(document)

    documents = gather_documents(document)

    disabled = []
    if documents.size.positive?
      documents.flatten!.each do |doc|
        disabled << doc.guide if doc.guide
        break if disabled.count == Document.guides.count
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
    if document.parent.methods.include? :descendants
      descendants = document.parent.descendants

      descendants.each do |descendant|
        documents << descendant.documents
      end
    end

    documents
  end
end
