# frozen_string_literal: true
require "rails_helper"

RSpec.describe TabsHelper do
  describe "#developer_development_tabs" do
    let(:developments_title) { I18n.t("developers.developments.tabs.developments") }
    let(:divisions_title) { I18n.t("developers.developments.tabs.divisions") }

    it "should return an array of tabs" do
      developer = create(:developer)
      developments_path = developer_developments_path(developer)
      divisions_path = developer_divisions_path(developer)

      result = developer_development_tabs(developer, "")
      developments = result.first
      divisions = result.last

      expect(developments[0]).to eq(developments_title)
      expect(developments[2]).to eq(developments_path)

      expect(divisions[0]).to eq(divisions_title)
      expect(divisions[2]).to eq(divisions_path)
    end

    context "given :divisions as the active tab" do
      it "should mark divisions as active" do
        developer = create(:developer)

        result = developer_development_tabs(developer, :divisions)
        developments = result.first
        divisions = result.last

        expect(developments[3]).to eq(false)
        expect(divisions[3]).to eq(true)
      end
    end

    context "given :developments as the active tab" do
      it "should mark developments as active" do
        developer = create(:developer)

        result = developer_development_tabs(developer, :developments)
        developments = result.first
        divisions = result.last

        expect(developments[3]).to eq(true)
        expect(divisions[3]).to eq(false)
      end
    end
  end
end
