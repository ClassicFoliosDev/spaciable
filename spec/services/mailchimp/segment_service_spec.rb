# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mailchimp::SegmentService do
  let(:developer) { create(:developer) }
  let(:current_user) { create(:developer_admin, developer: developer) }
  let(:development) { create(:development, developer: developer) }

  context "creating a development" do
    it "builds the segment conditions" do
      segment_params = described_class.build_segment_params(development)

      expect(segment_params).to include(
        name: development.name,
        options: { match: "any", conditions: [{ condition_type: "TextMerge",
                                                field: "DEVT",
                                                op: "is",
                                                value: development.name }] }
      )
    end
  end
end
