# frozen_string_literal: true

require "rails_helper"

RSpec.describe Development do
  describe "#name=" do
    context "under the same developer" do
      it "should not allow duplicate development names" do
        name = "Only development named this"
        developer = create(:developer)
        create(:development, name: name, developer: developer)
        development = Development.new(name: name, developer: developer)

        development.validate
        name_errors = development.errors.details[:name]

        expect(name_errors).to include(error: :taken, value: name)
      end

      it "should not allow development name with dash" do
        development_name = "Development with-dash"
        development = Development.new(name: development_name)

        development.validate
        expect(development.errors.details[:base]).to include(error: :invalid_name, value: development_name)
      end

      it "should not allow development name with comma" do
        development_name = "Development with,comma"
        development = Development.new(name: development_name)

        development.validate
        expect(development.errors.details[:base]).to include(error: :invalid_name, value: development_name)
      end

      it "should not allow development name with apostrophe" do
        development_name = "Development with'apostrophe"
        development = Development.new(name: development_name)

        development.validate
        expect(development.errors.details[:base]).to include(error: :invalid_name, value: development_name)
      end

      it "should not allow development name with at_sign" do
        development_name = "Development with @at_sign"
        development = Development.new(name: development_name)

        development.validate
        expect(development.errors.details[:base]).to include(error: :invalid_name, value: development_name)
      end
    end

    context "under different developers" do
      it "should allow duplicate development names" do
        name = "Only development named this"
        create(:development, name: name)
        development = Development.new(name: name)

        development.validate
        name_errors = development.errors.details[:name]

        expect(name_errors).not_to include(error: :taken, value: name)
      end
    end

    context "under the same division" do
      it "should not allow duplicate development names" do
        name = "Only development named this"
        division = create(:division)
        create(:division_development, name: name, division: division)
        development = build(:division_development, name: name, division: division)

        development.validate
        name_errors = development.errors.details[:name]

        expect(name_errors).to include(error: :taken, value: name)
      end
    end

    context "under different divisions" do
      it "should allow duplicate development names" do
        name = "Only development named this"
        create(:division_development, name: name)
        development = build(:division_development, name: name)

        development.validate
        name_errors = development.errors.details[:name]

        expect(name_errors).not_to include(error: :taken, value: name)
      end
    end
  end

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

  describe "#brand_any" do
    let(:developer) { create(:developer) }
    let(:development) { create(:development, developer: developer) }

    context "there is a development with a developer" do
      it "returns nil if no brand has been configured" do
        response = development.brand_any
        expect(response).to be_nil
      end

      it "returns development brand if there is one" do
        brand = create(:brand, brandable: development)

        response = development.brand_any
        expect(response).to eq(brand)
      end

      it "returns developer brand if there is no development brand" do
        brand = create(:brand, brandable: developer)

        response = development.brand_any
        expect(response).to eq(brand)
      end

      it "does not return the developer brand when there is a development brand" do
        developer_brand = create(:brand, brandable: developer)
        brand = create(:brand, brandable: development)

        response = development.brand_any
        expect(response).to eq(brand)
        expect(response).not_to eq(developer_brand)
      end
    end

    context "there is a development with a division" do
      let(:developer) { create(:developer) }
      let(:division) { create(:division, developer: developer) }
      let(:development) { create(:development, division: division) }

      it "returns nil if no brand has been configured" do
        response = development.brand_any
        expect(response).to be_nil
      end

      it "returns development brand if there is one" do
        brand = create(:brand, brandable: development)

        response = development.brand_any
        expect(response).to eq(brand)
      end

      it "returns division brand when there is no development brand" do
        brand = create(:brand, brandable: division)

        response = development.brand_any
        expect(response).to eq(brand)
      end

      it "returns developer brand when there is no development or division brand" do
        brand = create(:brand, brandable: developer)

        response = development.brand_any
        expect(response).to eq(brand)
      end

      it "returns development brand when there are brands on division and developer" do
        brand = create(:brand, brandable: development)
        division_brand = create(:brand, brandable: division)
        developer_brand = create(:brand, brandable: developer)

        response = development.brand_any
        expect(response).to eq(brand)
        expect(response).not_to eq(division_brand)
        expect(response).not_to eq(developer_brand)
      end
    end
  end
end
