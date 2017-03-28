# frozen_string_literal: true
module Homeowners
  class ContactsController < Homeowners::BaseController
    load_and_authorize_resource :contact

    def index
      @category = contact_params[:category]
      @contacts = @contacts.where(category: @category).order(updated_at: :desc)
      @categories = Contact.categories.keys
    end

    private

    def contact_params
      params.permit(:category)
    end
  end
end
