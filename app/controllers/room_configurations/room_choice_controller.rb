# frozen_string_literal: true

module RoomConfigurations
  class RoomChoiceController < ActionController::Base
    skip_authorization_check

    def item_categories
      if params[:itemType] == Appliance.to_s
        categories = ApplianceCategory.all
      elsif params[:itemType] == Finish.to_s
        categories = FinishCategory.all
      end

      cats = categories.map do |category|
        {
          name: category.name,
          id: category.id,
          selected: false
        }
      end

      render json: cats.to_json
    end

    # rubocop:disable Metrics/MethodLength
    def category_items
      if params[:itemType] == Appliance.to_s
        category_items = Appliance.where(appliance_category_id: params[:categoryId])
      elsif params[:itemType] == Finish.to_s
        category_items = Finish.where(finish_category_id: params[:categoryId])
      end

      items = []
      if category_items
        category_items = category_items.sort_by(&:full_name)
        items = category_items.map do |item|
          {
            name: item.full_name,
            id: item.id,
            selected: false
          }
        end
      end

      render json: items.to_json
    end
    # rubocop:enable Metrics/MethodLength

    def room_items
      roomconfig = RoomConfiguration
                   .where(choice_configuration_id: params[:choice_configuration])
                   .where("lower(name) = ?", params[:roomName].downcase).first

      items = []
      unless roomconfig.nil?
        items = RoomItem.where(room_configuration_id: roomconfig.id).map do |item|
          {
            id: item.id,
            name: item.name
          }
        end
      end

      render json: items.to_json
    end

    def item_choices
      choices = Choice.where(room_item_id: params[:roomItem], archived: false).map do |choice|
        {
          id: choice.id,
          name: current_resident ? choice.short_name : choice.full_name
        }
      end

      render json: choices.to_json
    end

    def item_images
      images = Choice.where(room_item_id: params[:roomItem], archived: false).map do |choice|
        item = choice.choiceable
        {
          id: choice.id,
          name: item.short_name,
          url: if item.is_a?(Appliance)
                 item.primary_image.thumbnail.url
               else
                 item.picture.thumbnail.url
               end
        }
      end

      render json: images.to_json
    end

    def export_choices
      plot = Plot.find(params[:plot_id])
      return if plot.blank?
      choices_csv = Csv::ChoicesCsvService.call(plot)
      send_file(choices_csv, disposition: :attachment)
    end

    def archive_choice
      choice = Choice.find(params[:choice_id])
      choice.update(archived: true) if choice.present?
    end
  end
end
