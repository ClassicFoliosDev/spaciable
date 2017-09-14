# frozen_string_literal: true
require "rails_helper"
RSpec.describe AppliancesFinishesErrorsService do
  context "creates errors for invalid entities" do
    it "should not report errors for room with appliance and finish deleted" do
      finish_category = create(:finish_category)
      finish_type = create(:finish_type, finish_categories: [finish_category])
      finish = create(:finish, finish_type: finish_type, finish_category: finish_category)
      appliance = create(:appliance)
      room = create(:room)
      create(:finish_room, finish: finish, room: room)
      create(:appliance_room, appliance: appliance, room: room)

      finish.delete
      appliance.delete

      errors = described_class.room_errors(room)
      expect(errors).to eq ""
    end

    it "should report errors for invalid room" do
      finish_category = create(:finish_category)
      finish_type = create(:finish_type, finish_categories: [finish_category])
      finish = create(:finish, finish_type: finish_type, finish_category: finish_category)
      appliance = create(:appliance)
      room = create(:room)

      create(:finish_room, finish: finish, room: room)
      create(:appliance_room, appliance: appliance, room: room)

      room.reload
      stub_room_errors

      errors = described_class.room_errors(room)
      expect(errors).to eq " #{room} Appliance #{appliance.id} horribly #{room} Finish #{finish.id} wrong"
    end
  end

  def stub_room_errors
    allow_any_instance_of(FinishRoom).to receive_message_chain(:errors, :messages).and_return(finish: ["wrong"])
    allow_any_instance_of(ApplianceRoom).to receive_message_chain(:errors, :messages).and_return(appliance: ["horribly"])
  end
end
