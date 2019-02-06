# frozen_string_literal: true

module Homeowners
  class ContactsController < Homeowners::BaseController
    skip_authorization_check
    load_and_authorize_resource :contact

    before_action :set_populated_categories, only: %i[index]

    def index
      @category = contact_params[:category]
      @contacts = @contacts.where(category: @category).order(updated_at: :desc)

      redirect_to @contacts_for.values[0] if @contacts.none? && @contacts_for.any?
    end

    private

    def contact_params
      params.permit(:category)
    end

    # Work out which of the contact categories has data and populate a hash for all that do.
    def set_populated_categories
      @categories = Contact.categories.keys

      @contacts_for = {}
      @categories.each do |cat|
        if Contact.accessible_by(current_ability).where(category: cat).any?
          @contacts_for[cat] = homeowner_contacts_path(cat)
        end
      end
    end
  end
end
