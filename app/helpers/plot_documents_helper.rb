# frozen_string_literal: true

module PlotDocumentsHelper
  def parent_assigned_manual(parent)
    return unless parent.is_a?(Phase) || parent.is_a?(Development)

    documents = parent_documents(parent)

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

  def parent_documents(parent)
    documents = []

    # parent documents
    while parent do
      documents << parent.documents
      parent = parent.parent
      break if (parent.is_a? Developer) || (parent.is_a? Division)
    end

    documents
  end
end
