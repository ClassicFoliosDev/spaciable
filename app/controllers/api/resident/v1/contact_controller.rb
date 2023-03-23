# frozen_string_literal: true

module Api
  module Resident
    module V1
      class ContactController < Api::Resident::ResidentController

        def index
          render json: Contact.accessible_by(current_ability).to_json, status: 200
          #render json: contacts.to_json, status: 200
        end
      end
    end
  end
end
