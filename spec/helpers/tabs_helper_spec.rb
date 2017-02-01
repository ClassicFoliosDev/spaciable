# frozen_string_literal: true
require "rails_helper"

RSpec.describe DeveloperTabsHelper do
  describe "#developer_tabs" do
    let(:divisions_title) { I18n.t("developers.collection.divisions") }
    let(:documents_title) { I18n.t("developers.collection.documents") }
    let(:faqs_title) { I18n.t("developers.collection.faqs") }

    it "should return an array of tabs" do
      developer = create(:developer)
      divisions_path = developer_path(developer) + "?active_tab=divisions"
      documents_path = developer_path(developer) + "?active_tab=documents"

      result = developer_tabs(developer, "")
      divisions = result.first
      documents = result.third

      expect(divisions[0]).to eq(divisions_title)
      expect(divisions[2]).to eq(divisions_path)

      expect(documents[0]).to eq(documents_title)
      expect(documents[2]).to eq(documents_path)
    end

    context "given :divisions as the active tab" do
      it "should mark divisions as active" do
        developer = create(:developer)

        result = developer_tabs(developer, "divisions")
        divisions = result.first
        documents = result.last

        expect(documents[3]).to eq(false)
        expect(divisions[3]).to eq(true)
      end
    end

    context "given :developments as the active tab" do
      it "should mark developments as active" do
        developer = create(:developer)

        result = developer_tabs(developer, "developments")
        divisions = result.first
        developments = result.second

        expect(developments[3]).to eq(true)
        expect(divisions[3]).to eq(false)
      end
    end
  end
end
