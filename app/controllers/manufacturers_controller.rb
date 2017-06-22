# frozen_string_literal: true
class ManufacturersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :manufacturer

  def index
    @manufacturers = paginate(sort(@manufacturers, default: :name))
    @active_tab = "manufacturers"

    if request&.referrer && @parent.nil?
      parent_type = URI(request.referer).path
      @parent = if parent_type == "/finishes"
                  Finish.new
                else
                  Appliance.new
                end
    elsif @parent.nil?
      @parent = Appliance.new
    end
  end

  def show
  end

  def new
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def edit
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def update
    update_relationships(assign_to_appliances)
    if @manufacturer.update(manufacturer_params)
      notice = t("controller.success.update", name: @manufacturer.name)
      if assign_to_appliances
        redirect_to manufacturers_path, notice: notice
      else
        redirect_to "/finishes", notice: notice, active_tab: "manufacturers"
      end
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :edit
    end
  end

  def create
    if @manufacturer.save
      create_relationships(assign_to_appliances)
      notice = t("controller.success.create", name: @manufacturer.name)
      if assign_to_appliances
        redirect_to manufacturers_path, notice: notice
      else
        redirect_to "/finishes", notice: notice, active_tab: "manufacturers"
      end
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :new
    end
  end

  def destroy
    @manufacturer.destroy
    notice = t("controller.success.destroy", name: @manufacturer.name)
    redirect_to manufacturers_path, notice: notice

  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @manufacturer.name,
               types: "appliances or finishes")
    redirect_to manufacturers_path, alert: notice
  end

  private

  def assign_to_appliances
    manufacturer_params[:assign_to_appliances] == "true"
  end

  def create_relationships(assign_to_appliances)
    if assign_to_appliances
      RelationshipsService.join_appliance_category_manufacturers(@manufacturer.id)
    else
      RelationshipsService
        .join_finish_type_manufacturers(@manufacturer,
                                        manufacturer_params[:finish_category_id])
    end
  end

  def update_relationships(assign_to_appliances)
    if assign_to_appliances
      RelationshipsService.join_appliance_category_manufacturers(@manufacturer.id)
      RelationshipsService.remove_finish_type_manufacturers(@manufacturer)
    else
      RelationshipsService.remove_appliance_category_manufacturers(@manufacturer)
      RelationshipsService
        .join_finish_type_manufacturers(@manufacturer,
                                        manufacturer_params[:finish_category_id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def manufacturer_params
    params.require(:manufacturer).permit(
      :name,
      :link,
      :assign_to_appliances,
      :finish_category_id
    )
  end
end
