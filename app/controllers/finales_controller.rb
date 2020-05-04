# frozen_string_literal: true

class FinalesController < ApplicationController
  load_and_authorize_resource :timeline
  load_and_authorize_resource :finale
  load_and_authorize_resource :task

  before_action :set_complete

  def new; end

  def edit; end

  def show; end

  def update
    if @finale.update(finale_params)
      notice = t(".finale_updated", name: @timeline.title) if notice.nil?
      redirect_to [@timeline], notice: notice
    else
      render :edit
    end
  end

  def create
    if @finale.save
      notice = t(".finale_created", name: @timeline.title) if notice.nil?
      redirect_to [@timeline], notice: notice
    else
      render :new
    end
  end

  def finale_params
    params.require(:finale).permit(
      :task_id, :timeline_id,
      :complete_message, :complete_picture, :complete_picture_cache,
      :incomplete_message, :incomplete_picture, :incomplete_picture_cache
    )
  end

  private

  def set_complete
    @complete ||= params[:complete] || true
  end
end
