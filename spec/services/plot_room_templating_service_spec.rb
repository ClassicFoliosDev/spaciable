# frozen_string_literal: true
require "rails_helper"

RSpec.describe PlotRoomTemplatingService do
  describe "#build_room" do
    context "with a template_room_id" do
      it "should build a plot room linked to the template room" do
        unit_type = create(:unit_type)
        unit_type_room = create(:room, unit_type: unit_type)
        plot = create(:plot, unit_type: unit_type)

        service = described_class.new(plot)
        room = service.build_room(template_room_id: unit_type_room.id, room_scope: Room.all)

        expect(room.template_room_id).to eq(unit_type_room.id)
        expect(room.plot_id).to eq(plot.id)
        expect(room.unit_type_id).to be_nil
      end
    end

    context "without a template_room_id" do
      it "should build a plot room" do
        plot = create(:plot)

        service = described_class.new(plot)
        room = service.build_room

        expect(room.template_room_id).to be_nil
        expect(room.plot_id).to eq(plot.id)
        expect(room.unit_type_id).to be_nil
      end
    end
  end

  describe "#clone_room" do
    it "should clone a room for a plot, but only once" do
      unit_type = create(:unit_type)
      unit_type_room = create(:room, unit_type: unit_type)
      plot = create(:plot, unit_type: unit_type)

      new_room = described_class.clone_room(plot.id, unit_type_room)

      expect(new_room.name).to eq(unit_type_room.name)
      expect(new_room.id).not_to eq(unit_type_room.id)
      expect(new_room.unit_type_id).to be_nil
      expect(new_room.plot_id).to eq(plot.id)
      expect(new_room.template_room_id).to eq(unit_type_room.id)

      response = described_class.clone_room(plot.id, new_room)
      expect(response).to be_nil
    end
  end

  describe "#destroy" do
    context "when the room is a template room" do
      it "should not delete the template room" do
        unit_type = create(:unit_type)
        unit_type_room = create(:room, unit_type: unit_type)
        plot = create(:plot, unit_type: unit_type)

        described_class.new(plot).destroy(unit_type_room)

        expect(unit_type_room).not_to be_deleted
      end

      it "should create a deleted plot room" do
        unit_type = create(:unit_type)
        unit_type_room = create(:room, unit_type: unit_type)
        plot = create(:plot, unit_type: unit_type)

        plot_room = described_class.new(plot).destroy(unit_type_room)

        expect(plot_room).to be_deleted
      end
    end

    context "when the room is a plot room" do
      it "should destroy the plot room" do
        room = create(:plot_room)

        described_class.new(room.plot).destroy(room)

        expect(room).to be_deleted
      end
    end
  end
end
