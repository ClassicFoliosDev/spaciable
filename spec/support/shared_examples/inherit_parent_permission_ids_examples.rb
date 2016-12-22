# frozen_string_literal: true
RSpec.shared_examples "it inherits permissable ids from the parent" do
  describe "#permissable_ids" do
    it "must have a developer_id or division_id" do
      resource = described_class.new(developer_id: nil, division_id: nil)

      resource.validate

      error = I18n.t("activerecord.errors.messages.missing_permissable_id")
      expect(resource.errors[:base]).to include(error)
    end

    describe "#developer_id" do
      it "sets it based on a parents developer_id" do
        developer = create(:developer)
        parent.developer = developer
        parent.division = nil

        resource = parent.send(association_with_parent).new
        resource.validate

        expect(resource.developer_id).to eq(developer.id)
      end
    end

    describe "#division_id" do
      it "sets it based on a parents division_id" do
        division = create(:division)
        parent.developer = nil
        parent.division = division

        resource = parent.send(association_with_parent).new
        resource.validate

        expect(resource.division_id).to eq(division.id)
      end
    end
  end
end

RSpec.shared_examples "it inherits the development_id from the parent" do
  it "should set the development_id" do
    development = create(:development)
    parent.development = development

    resource = parent.send(:association_with_parent).new
    resource.validate

    expect(resource.development).to eq(development)
  end
end
