# frozen_string_literal: true

class RoomChoice < ApplicationRecord
  belongs_to :plot
  belongs_to :room_item
  belongs_to :choice

  delegate :name, to: :room_item
  delegate :room, to: :room_item
  delegate :full_name, to: :choice

  # rubocop:disable all
  def self.renew(plot_id, room_choices, status)
    success = true
    e = ""
    RoomChoice.transaction do
      begin
        delete_all(plot_id)
        add_all(plot_id, room_choices)
        Plot.find(plot_id).update(choice_selection_status: status)
      rescue => e
        puts "@@@@@@@ #{e}"
        success = false
      end
    end
    return success, e
  end
  # rubocop:enable all

  def self.delete_all(plot_id)
    RoomChoice.where(plot_id: plot_id).delete_all
  end

  def self.add_all(plot_id, room_choices)
    room_choices.each do |roomitemid, choiceid|
      RoomChoice.create(plot_id: plot_id, room_item_id: roomitemid, choice_id: choiceid).save!
    end
  end

  # Get the choices made for the room by the plot
  def self.plot_choices(room, plot)
    # https://stackoverflow.com/questions/29071052/how-to-use-join-query-for-4-tables-in-rails
    Choice.joins(room_choices: { room_item: :room_configuration })
          .where("room_choices.plot_id = #{plot.id} AND " \
                 "lower(room_configurations.name) = '#{room.name.downcase}'")
  end

  # Get the approved choices of the provided type made for the room by the plot
  def self.approved_choices(room, plot, type)
    return unless plot.choices_approved?

    choices = Choice.joins(room_choices: { room_item: :room_configuration })
                    .where("room_choices.plot_id = #{plot.id} AND " \
                           "lower(room_configurations.name) = '#{room.name.downcase}' AND " \
                           "choices.choiceable_type = '" + type.to_s + "'").to_a
    choices&.map!(&:choiceable)
  end
end
