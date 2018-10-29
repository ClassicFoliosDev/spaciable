# frozen_string_literal: true

require "rails_helper"

RSpec.describe Homeowners::ResidentsController do

  describe "#show_how_to" do
    scenario "it returns the requested how to" do
      how_to = create(:how_to)

      get "/how_tos/#{how_to.id}"

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      expect(body["title"]).to eq how_to.title
      expect(body["summary"]).to eq how_to.summary
      expect(body["description"]).to eq how_to.description
    end

    scenario "it returns not found for nonexistent id" do
      get "/how_tos/12"
      expect(response.status).to eq 404

      get "/how_tos/wrong"
      expect(response.status).to eq 404
    end
  end
end
