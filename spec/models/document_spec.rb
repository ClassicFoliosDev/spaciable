# frozen_string_literal: true
require "rails_helper"

RSpec.describe Document do
  context "documentable is a developer" do
    let(:developer) { create(:developer) }
    subject { described_class.new(documentable: developer) }
    it "should set the developer_id" do
      subject.validate
      expect(subject.developer_id).to eq(developer.id)
    end
    it "should not set the division_id" do
      subject.validate
      expect(subject.division_id).to be_nil
    end
    it "should not set the development_id" do
      subject.validate
      expect(subject.development_id).to be_nil
    end
  end
  context "documentable is a division" do
    let(:developer) { create(:developer) }
    let(:division) { create(:division, developer: developer) }
    subject { described_class.new(documentable: division) }
    it "should set the developer_id" do
      subject.validate
      expect(subject.developer_id).to eq(developer.id)
    end
    it "should set the division_id" do
      subject.validate
      expect(subject.division_id).to eq(division.id)
    end
    it "should not set the development_id" do
      subject.validate
      expect(subject.development_id).to be_nil
    end
  end
  context "documentable is a development" do
    let(:developer) { create(:developer) }
    let(:development) { create(:development, developer: developer) }
    subject { described_class.new(documentable: development) }
    it "should set the developer_id" do
      subject.validate
      expect(subject.developer_id).to eq(developer.id)
    end
    it "should not set the division_id" do
      subject.validate
      expect(subject.division_id).to be_nil
    end
    it "should set the development_id" do
      subject.validate
      expect(subject.development_id).to eq(development.id)
    end
  end
  context "documentable is a division development" do
    let(:developer) { create(:developer) }
    let(:division) { create(:division, developer: developer) }
    let(:development) { create(:division_development, division: division) }
    subject { described_class.new(documentable: development) }
    it "should set the developer_id" do
      subject.validate
      expect(subject.developer_id).to eq(developer.id)
    end
    it "should set the division_id" do
      subject.validate
      expect(subject.division_id).to eq(division.id)
    end
    it "should set the development_id" do
      subject.validate
      expect(subject.development_id).to eq(development.id)
    end
  end
  context "documentable is a resource under development" do
    let(:developer) { create(:developer) }
    let(:division) { create(:division, developer: developer) }
    let(:development) { create(:division_development, division: division) }
    let(:phase) { create(:phase, development: development) }
    subject { described_class.new(documentable: development) }
    it "should set the developer_id" do
      subject.validate
      expect(subject.developer_id).to eq(developer.id)
    end
    it "should set the division_id" do
      subject.validate
      expect(subject.division_id).to eq(division.id)
    end
    it "should set the development_id" do
      subject.validate
      expect(subject.development_id).to eq(development.id)
    end
  end
end
