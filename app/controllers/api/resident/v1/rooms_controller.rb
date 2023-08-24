# frozen_string_literal: true
require 'json'

module Api
  module Resident
    module V1
      class RoomsController < Api::Resident::ResidentController

        def index
          rooms = @plot.rooms
                       .includes(:finish_rooms,
                                  :finishes,
                                  :finish_manufacturers,
                                  :appliance_rooms,
                                  :appliances,
                                  :appliance_manufacturers,
                                  :appliance_categories)

          pop_rooms = []
          rooms.reject { |r| !((r.appliances.any? && (%w[mixed appliances].any? { |c| params["content"].include? c })) ||
                               (r.finishes.any? && (%w[mixed finishes].any? { |c| params["content"].include? c })))}.each do |room|
            pop_rooms << {
              id: room.id,
              name: room.name,
              icon: room.icon_name,
              finishes: finishes(room),
              appliances: appliances(room)
            }
          end

          render json: pop_rooms.to_json, status: :ok
        end

        private

        def finishes(room)
          finishes = []
          room.finishes.each do |finish|
            finishes << {
              id: finish.id,
              link: finish.picture.url,
              category: finish.finish_category.name,
              type: finish.finish_type.name,
              manufacturer: finish.finish_manufacturer.name,
              name: finish.name
            }
          end

          finishes
        end

        def appliances(room)
          appliances = []
          room.appliances.each do |appliance|
            appliances << {
              id: appliance.id,
              primary_image: appliance.primary_image.url,
              secondary_image: appliance.secondary_image.url,
              manufacturer_link: appliance.appliance_manufacturer_link,
              manufacturer: appliance&.appliance_manufacturer.name,
              model_num: appliance.model_num,
              manual_link: appliance&.manual.url,
              guide_link: appliance&.guide.url,
              category: {
                id: appliance.appliance_category.id,
                name: appliance.appliance_category.name
              },
              name: appliance.full_name,
              warranty: appliance.warranty_length
            }
          end

          appliances
        end

      end
    end
  end
end
