# frozen_string_literal: true
require "rails_helper"

RSpec.describe Development do
  describe "#parent" do
    it "must have a developer_id or division_id" do
      development = described_class.new(developer_id: nil, division_id: nil)

      development.validate

      error = I18n.t("activerecord.errors.messages.missing_permissable_id")
      expect(development.errors[:base]).to include(error)
    end

    context "when it belongs to a division" do
      it "should be the division" do
        division = create(:division)
        development = described_class.new(division: division)

        expect(development.parent).to eq(division)
      end
    end

    context "when it belongs to a developer" do
      it "should be the developer" do
        developer = create(:developer)
        development = described_class.new(developer: developer)

        expect(development.parent).to eq(developer)
      end
    end
  end

  describe "plots" do
    it "does not include phase plots" do
      development = create(:development)
      phase = create(:phase, development: development)
      development_plot = create(:plot, development: development)
      phase_plot = create(:plot, development: development, phase: phase)

      expect(development.plots).to include(development_plot)
      expect(development.plots).not_to include(phase_plot)
    end
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:development) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
    it_behaves_like "archiving is dependent on parent association", :division do
      subject { FactoryGirl.create(:division_development) }
    end
  end
end
