# frozen_string_literal: true
require "rails_helper"

RSpec.describe DevelopmentFinderService do
  let(:developer) { create(:developer) }
  let(:developer2) { create(:developer) }
  let(:division) { create(:division, developer: developer) }
  let(:development_with_same_name1) do
    create(:development,
           developer_id: developer.id)
  end
  let(:development_with_same_name2) do
    create(:development,
           developer_id: developer2.id,
           name: development_with_same_name1.name)
  end
  let(:development_with_same_name3) do
    create(:development,
           division_id: division.id,
           developer_id: nil,
           name: development_with_same_name1.name)
  end

  let(:development_with_unique_name) do
    create(:development,
           developer_id: developer.id)
  end

  context "with a single development in a developer" do
    it "should find the development" do
      sign_in_params = {
        developer_name: developer.to_s.parameterize,
        development_name: development_with_unique_name.to_s.parameterize
      }
      result = described_class.call(sign_in_params)

      expect(result.id).to eq(development_with_unique_name.id)
      expect(result.to_s).to eq(development_with_unique_name.name)
    end
  end

  context "with multiple developments in different developers" do
    it "should find the development (with no division) from the developer" do
      development_with_same_name2
      development_with_same_name3

      sign_in_params = {
        developer_name: developer.to_s.parameterize,
        development_name: development_with_same_name1.to_s.parameterize
      }
      development = described_class.call(sign_in_params)

      expect(development.id).to eq(development_with_same_name1.id)
      expect(development.to_s).to eq(development_with_same_name1.name)
      expect(development.developer.to_s).to eq(developer.company_name)
      expect(development.developer.id).to eq(developer.id)
    end
  end

  context "with development in division and multiple developments" do
    it "should find the development from the division" do
      development_with_same_name1
      development_with_same_name3

      sign_in_params = {
        developer_name: developer.to_s.parameterize,
        division_name: division.to_s.parameterize,
        development_name: development_with_same_name3.to_s.parameterize
      }
      development = described_class.call(sign_in_params)

      expect(development.id).to eq(development_with_same_name3.id)
      expect(development.to_s).to eq(development_with_same_name3.name)
      expect(development.division.to_s).to eq(division.division_name)
      expect(development.division.id).to eq(division.id)
      expect(development.division.developer.to_s).to eq(developer.company_name)
      expect(development.division.developer.id).to eq(developer.id)

      sign_in_params = {
        developer_name: developer.to_s.parameterize,
        development_name: development_with_same_name1.to_s.parameterize
      }
      development = described_class.call(sign_in_params)

      expect(development.id).to eq(development_with_same_name1.id)
      expect(development.to_s).to eq(development_with_same_name1.name)
      expect(development.developer.to_s).to eq(developer.company_name)
      expect(development.developer.id).to eq(developer.id)
    end
  end
end
