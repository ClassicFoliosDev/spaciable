# frozen_string_literal: true

class AppliancesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :appliance, except: %i[appliance_manufacturers_list appliance_list]
  skip_authorization_check only: %i[appliance_manufacturers_list appliance_list]

  def index
    @filter = filter
    @afilter = ApplianceFilter.new(filter_params)
    @appliances = Appliance.filtered(@afilter, @current_ability)
    @appliances = paginate(sort(@appliances, default: :id))
    @active_tab = "appliances"
  end

  def new; end

  def edit; end

  def show
    @warn_on_edit = parse_boolean(params[:warn_on_edit])
    @origin = params[:origin]
  end

  def create
    clone_files if params[:appliance][:copy_of].present?
    if @appliance.save
      notice = t(".success", name: @appliance.full_name)
      redirect_to appliances_path, notice: notice
    else
      if params[:appliance][:copy_of].present?
        @source_appliance = Appliance.find(params[:appliance][:copy_of])
      end
      render :new
    end
  end

  def update
    if @appliance.update(appliance_params)
      notice = t(".success", name: @appliance.full_name)
      redirect_to appliances_path, notice: notice
    else
      render :edit
    end
  end

  def destroy
    @appliance.really_destroy!
    notice = t(".success", name: @appliance.to_s)
    redirect_to appliances_path, notice: notice
  end

  def clone
    @source_appliance = @appliance
    @appliance = @appliance.dup
  end

  # Copy files from the source appliance providing the new appliance
  # hasn't already assigned new files
  def clone_files
    %i[primary_image secondary_image manual guide].each do |f|
      next unless !(params[:appliance][f] || parse_boolean(params[:appliance]["remove_#{f}"])) &&
                  Appliance.find(params[:appliance][:copy_of]).send("#{f}?")

      CopyCarrierwaveFile::CopyFileService.new(
        Appliance.find(params[:appliance][:copy_of]), @appliance, f
      ).set_file
    end
  end

  def appliance_manufacturers_list
    appliance_manufacturers = ApplianceManufacturer.visible_to(current_user).order(:name)
    render json: appliance_manufacturers
  end

  def appliance_list
    appliances = Appliance.with_cat_man(params, current_user)
    render json: appliances
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def appliance_params
    p = params.require(:appliance).permit(
      :primary_image, :secondary_image, :manual,
      :serial, :source, :warranty_num, :description,
      :warranty_length, :model_num, :e_rating,
      :appliance_manufacturer_id, :appliance_category_id,
      :remove_primary_image, :remove_secondary_image,
      :remove_manual, :guide, :remove_guide,
      :primary_image_cache, :secondary_image_cache,
      :main_uk_e_rating, :supp_uk_e_rating
    )

    %i[remove_primary_image remove_secondary_image remove_manual remove_guide].each do |i|
      p[i] = "0" if p["remove_#{i}"].present?
    end

    p
  end

  def filter_params
    return unless params.include?("appliance_filter")

    params.require("appliance_filter").permit(:appliance_category_id,
                                              :appliance_manufacturer_id)
  end

  def filter
    return {} unless params.include?("appliance_filter")

    f = params.permit(appliance_filter: %i[appliance_category_id
                                           appliance_manufacturer_id])
    f.to_h
  end
end
