# frozen_string_literal: true
class FinishTypesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :finish_type

  def index
    @finish_types = paginate(sort(@finish_types, default: :name))
    @active_tab = "finish_types"
  end

  def show; end

  def new
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def edit
    @finish_categories = sort(FinishCategory.all, default: :name)
  end

  def update
    if @finish_type.update(finish_type_params)
      RelationshipsService.join_finish_category_types(@finish_type,
                                                      finish_type_params[:finish_category_id])
      notice = t("controller.success.update", name: @finish_type.name)
      redirect_to finish_types_path, notice: notice
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :edit
    end
  end

  def create
    if @finish_type.save
      RelationshipsService.join_finish_category_types(@finish_type,
                                                      finish_type_params[:finish_category_id])
      notice = t("controller.success.create", name: @finish_type.name)
      redirect_to finish_types_path, notice: notice
    else
      @finish_categories = sort(FinishCategory.all, default: :name)
      render :new
    end
  end

  def destroy
    @finish_type.destroy
    notice = t("controller.success.destroy", name: @finish_type.name)
    redirect_to finish_types_path, notice: notice

  rescue ActiveRecord::InvalidForeignKey
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @finish_type.name,
               types: "finishes")
    redirect_to finish_types_path, alert: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_type_params
    params.require(:finish_type).permit(
      :name,
      :finish_category_id
    )
  end
end
