# frozen_string_literal: true

class FinishesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :finish, except: %i[finish_types_list manufacturers_list finish_list]
  skip_authorization_check only: %i[finish_types_list manufacturers_list finish_list]

  def index
    @finishes = @finishes.includes(:finish_category, :finish_type, :finish_manufacturer)
    @finishes = paginate(sort(@finishes, default: :name))
    @active_tab = "finishes"
  end

  def new; end

  def edit; end

  def show
    @warn_on_edit = parse_boolean(params[:warn_on_edit])
    @origin = params[:origin]
  end

  # rubocop:disable LineLength, Metrics/AbcSize
  def create
    if !params[:finish][:picture] &&
       !parse_boolean(params[:finish][:remove_picture]) &&
       params[:finish][:copy_of].present?
      CopyCarrierwaveFile::CopyFileService.new(Finish.find(params[:finish][:copy_of]), @finish, :picture).set_file if Finish.find(params[:finish][:copy_of]).picture?
    end
    if @finish.save
      @finish.set_original_filename
      redirect_to finishes_path, notice: t("controller.success.create", name: @finish.name)
    else
      render :new
    end
  end
  # rubocop:enable LineLength, Metrics/AbcSize

  def update
    if @finish.update(finish_params)
      @finish.set_original_filename
      redirect_to finish_path, notice: t("controller.success.update", name: @finish.name)
    else
      render :edit
    end
  end

  def destroy
    @finish.really_destroy!
    notice = t(
      "controller.success.destroy",
      name: @finish.name
    )
    redirect_to finishes_url, notice: notice
  end

  def clone
    @source_finish = @finish
    @finish = @finish.dup
    render :new
  end

  def finish_types_list
    finish_types = FinishType.with_category(params[:category])
    render json: finish_types
  end

  def manufacturers_list
    manufacturers = FinishManufacturer.with_type(params[:type])
    render json: manufacturers
  end

  def finish_list
    finishes = if params[:manufacturer].present?
                 Finish.with_cat_type_man(params)
               else
                 Finish.with_cat_type(params)
                       .each { |f| f.name = "#{f.finish_manufacturer&.name} #{f.name}" }

               end

    render json: finishes
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def finish_params
    p = params.require(:finish).permit(
      :name,
      :description,
      :finish_category_id,
      :finish_type_id,
      :finish_manufacturer_id,
      :picture,
      :remove_picture,
      :picture_cache,
      documents_attributes: %i[id title file _destroy]
    )
    p[:remove_picture] = "0" if p[:picture].present?
    p
  end

  # Override the current_ability - supplying the non_development value
  # tailors the security and avoids problems perculiar to this controller
  def current_ability
    @current_ability ||= ::Ability.new(current_user, non_development: true)
  end
end
