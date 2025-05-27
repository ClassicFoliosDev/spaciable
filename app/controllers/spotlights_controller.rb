# frozen_string_literal: true

class SpotlightsController < ApplicationController
  load_and_authorize_resource :development
  load_and_authorize_resource :spotlight, through: :development, only: %i[index new create]
  load_and_authorize_resource :spotlight, only: %i[show edit update destroy]
  before_action :set_parent, except: [:swap]

  def index; end

  def new
    (redirect_to root_url unless current_user.cf_admin?) if @parent.expired?
    @spotlight.build(@development)
  end

  def edit
    (redirect_to spotlight_path unless current_user.cf_admin?) if @parent.expired?
    @spotlight.build(@development)
  end

  def show; end

  def create
    @spotlight.process(spotlight_params, false)
    if @spotlight.save
      notice = t("controller.success.create", name: "Spotlight")
      redirect_to [@parent, :spotlights], notice: notice
    else
      @spotlight.custom_tiles.first.image = nil
      @spotlight.build(@development)
      render :new
    end
  end

  def update
    @spotlight.process(spotlight_params)
    if @spotlight.update(spotlight_params)
      delete_images(spotlight_params)
      notice = t("controller.success.update", name: "Spotlight")
      redirect_to [@parent, :spotlights], notice: notice
    else
      @spotlight.build(@development)
      render :edit
    end
  end

  def destroy
    @spotlight.destroy
    notice = t("controller.success.destroy", name: "Spotlight")
    redirect_to [@parent, :spotlights], notice: notice
  end

  # rubocop:disable Metrics/LineLength, SkipsModelValidations
  def swap
    seq1 = Spotlight.find(params[:row1]).sequence_no
    Spotlight.find(params[:row1]).update_column(:sequence_no, Spotlight.find(params[:row2]).sequence_no)
    Spotlight.find(params[:row2]).update_column(:sequence_no, seq1)
    render json: {}, status: :ok
  end
  # rubocop:enable Metrics/LineLength, SkipsModelValidations

  private

  def set_parent
    @parent = @development || @spotlight.parent
    @brand = @parent&.branding if @parent&.present? && @parent.respond_to?(:branding)
  end

  def spotlight_params
    s_params = params.require(:spotlight).permit(
      :editable, :category, :appears, :start, :finish, :expiry, :all_or_nothing,
      custom_tiles_attributes: %i[category feature document_id guide
                                  link tileable_type tileable_id
                                  title render_title description image
                                  render_description button render_button
                                  image_cache remove_image full_image _destroy
                                  id order file]
    )
    s_params[:custom_tiles_attributes].each { |_, a| a[:remove_image] = "0" if a[:image] }
    s_params
  end

  def delete_images(s_params)
    @spotlight.custom_tiles.each_with_index do |t, i|
      next if s_params[:custom_tiles_attributes][i.to_s][:image]

      t.remove_image! if s_params[:custom_tiles_attributes][i.to_s][:remove_image] == "1"
    end
  end
end
