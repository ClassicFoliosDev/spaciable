# frozen_string_literal: true
module Homeowners
  class ContactsController < Homeowners::BaseController
    load_and_authorize_resource :contact

    def index
      @contacts = @contacts.where(category: contact_params[:category])
      @categories = Contact.categories.keys
      @brand = current_resident.brand
    end

    private

    def contact_params
      params.permit(:category)
    end
  end
end
