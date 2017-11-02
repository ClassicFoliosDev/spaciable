# frozen_string_literal: true

require "rails_helper"

RSpec.describe Division do
  describe "#division_name=" do
    context "under the same developer" do
      it "should not allow duplicate division names" do
        division_name = "Only division named this"
        developer = create(:developer)
        create(:division, division_name: division_name, developer: developer)
        division = Division.new(division_name: division_name, developer: developer)

        division.validate
        name_errors = division.errors.details[:division_name]

        expect(name_errors).to include(error: :taken, value: division_name)
      end

      it "should not allow division name with dash" do
        division_name = "Division with-dash"
        division = Division.new(division_name: division_name)

        division.validate
        expect(division.errors.details[:base]).to include(error: :invalid_name, value: division_name)
      end

      it "should not allow division name with comma" do
        division_name = "Division with,comma"
        division = Division.new(division_name: division_name)

        division.validate
        expect(division.errors.details[:base]).to include(error: :invalid_name, value: division_name)
      end

      it "should not allow division name with apostrophe" do
        division_name = "Division with'apostrophe"
        division = Division.new(division_name: division_name)

        division.validate
        expect(division.errors.details[:base]).to include(error: :invalid_name, value: division_name)
      end

      it "should not allow division name with at_sign" do
        division_name = "Division with @at_sign"
        division = Division.new(division_name: division_name)

        division.validate
        expect(division.errors.details[:base]).to include(error: :invalid_name, value: division_name)
      end
    end

    context "under different developers" do
      it "should allow duplicate division names" do
        division_name = "Only division named this"
        create(:division, division_name: division_name)
        division = Division.new(division_name: division_name)

        division.validate
        name_errors = division.errors.details[:division_name]

        expect(name_errors).not_to include(error: :taken, value: division_name)
      end
    end
  end

  describe "#destroy" do
    subject { FactoryGirl.create(:division) }

    include_examples "archive when destroyed"
    it_behaves_like "archiving is dependent on parent association", :developer
  end
end
