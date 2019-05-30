# frozen_string_literal: true

class RoomItemsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :room_configuration
  load_and_authorize_resource :room_item, through: :room_configuration

  before_action :set_choice_configuration
  before_action :set_item_types
  before_action :build_collection, only: %i[show]

  def create
    # The room_item fields bound to the form will be auto saved, but the selected items need to
    # be handled.  This wpuld be easy if they were not polymrphic but they are so they need to be
    # added explicitly within the room_item transaction
    room_item_params
    if @room_item.persist(params[:room_item][:category_item_ids])
      notice = t(".success", room_item_name: @room_item.name)
      redirect_to choice_configuration_room_configuration_path(@choice_configuration,
                                                               @room_configuration), notice: notice
    else
      render :new
    end
  end

  def edit
    build_item_categories
    build_category_items
  end

  def show() end

  def update
    if @room_item.update_room_item(params[:room_item][:category_item_ids],
                                   params[:room_item][:room_itemable_type],
                                   params[:room_item][:room_itemable_id],
                                   params[:room_item][:name])
      notice = t(".success", room_item_name: @room_item.name)
      redirect_to choice_configuration_room_configuration_path(@choice_configuration,
                                                               @room_configuration), notice: notice
    else
      render :edit
    end
  end

  def destroy
    @room_item.destroy
    notice = t(".destroy", room_item_name: @room_item.name)
    redirect_to choice_configuration_room_configuration_path(@choice_configuration,
                                                             @room_configuration), notice: notice
  end

  def room_item_params
    params.require(:room_item)
          .permit(
            :name,
            :room_itemable_type,
            :room_itemable_id,
            category_item_ids: []
          )
  end

  private

  # Each room item can be a selection of Appliances or a Finishes
  def set_item_types
    @item_types = [[Appliance.to_s, ApplianceCategory.to_s],
                   [Finish.to_s, FinishCategory.to_s]]
  end

  # get the grandparent - so the pages can go 'back'
  def set_choice_configuration
    @choice_configuration = ChoiceConfiguration.find(@room_configuration.choice_configuration_id)
  end

  # build a list of item categories for the selected type (ApplianceCategory/FinishCategory)
  def build_item_categories
    itemcategories = @room_item.room_itemable_type.singularize.classify.constantize.all
    @item_categories = itemcategories.map do |itemcategory|
      [
        itemcategory.name,
        itemcategory.id
      ]
    end
  end

  # Build the list of items in the selected category type (i.e Appliance->Oven) Set the choices
  # as 'selected'
  # rubocop:disable all
  def build_category_items
    itemtype = @room_item.room_itemable_type.slice(/.+?(?=Category)/).downcase # appliance/finish
    choices = @room_item.choices.pluck(:choiceable_id, :archived)
    categoryitems =  itemtype
                     .capitalize
                     .classify.constantize
                     .where("#{itemtype}_category_id": @room_item.room_itemable_id)
    @category_items = categoryitems.map do |categoryitem|
      [
        categoryitem.full_name,
        categoryitem.id,
        selected: !choices.select { |id, archived|
                    id == categoryitem.id && archived == false }.empty?
      ]
    end
  end
  # rubocop:enable all

  def build_collection
    @collection = @room_item.choices.map do |item|
      {
        name: item.choiceable.full_name,
        archived: item.archived,
        updated_at: item.updated_at
      }
    end
  end
end
