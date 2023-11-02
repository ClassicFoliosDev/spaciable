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

    # Sync object with Unlatch.  Different objects will have perform
    # specialist actions in order to synchronise
    def sync_with_unlatch
      raise "Not implemented"
    end

    # What Unlatch::Section should a document be put in.  Usually it
    # will go in the 'category' folder, but some documents have specialised
    # requirements and go elsewhere
    def section(document)
      Unlatch::Section.find_by(developer_id: document.unlatch_developer.id,
                               category: document.category)
    end

    # Synchronise all associated documents with Unlatch
    def sync_docs_with_unlatch
      documents.each(&:sync_with_unlatch)
    end

    # Is this object linked to an unlatch developer?
    def linked_to_unlatch?
      !unlatch_developer.nil?
    end

    # Is this object paired with an Unlatch object.  i.e. If this is a Development,
    # does it have an associated Unlatch::Program record?
    def paired_with_unlatch?
      false
    end
  end
end
