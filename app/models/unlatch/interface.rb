# frozen_string_literal: true

module Unlatch
  module Interface
    # get the list of associated Unlatch::Lots
    def lots
      []
    end

    # Does the object qualify to have docs added. This is
    # to guard against cases when a Phase or UnitType document
    # is added but doesn't have any associated plots. Any
    # document added to Unlatch with a blank array of plots
    # is visible to ALL plots.
    def sync_to_unlatch?
      true
    end

    # What Unlatch::Section should a document be put in
    def section(document)
      Unlatch::Section.find_by(developer_id: document.unlatch_developer.id,
                               category: document.category)
    end

    # Synchronise all associated documents with Unlatch
    def sync_docs_with_unlatch
      documents.each(&:sync_with_unlatch)
    end
  end
end
