# frozen_string_literal: true

class DevelopersController < ApplicationController
  include Ahoy::AnalyticsHelper
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :developer, except: %i[cas parameterize]
  skip_authorization_check only: %i[cas parameterize]

  def index
    @developers = paginate(sort(@developers, default: :company_name))
  end

  def new
    @developer.build_address unless @developer.address

    @branded_perk = BrandedPerk.new
    @developer.build_branded_perk unless @developer.branded_perk
  end

  def edit
    @developer.build_address unless @developer.address

    @branded_perk = BrandedPerk.new
    @developer.build_branded_perk unless @developer.branded_perk
  end

  def show
    @active_tab = params[:active_tab] || default_tab
    @collection = if @active_tab == "divisions"
                    divisions = @developer.divisions.accessible_by(current_ability)
                    paginate(sort(divisions, default: :division_name))
                  elsif @active_tab == "developments"
                    developments = @developer.developments.accessible_by(current_ability)
                    paginate(sort(developments, default: :name))
                  elsif @active_tab == "documents"
                    documents = @developer.documents.accessible_by(current_ability)
                    paginate(sort(documents, default: :title))
                  end
  end

  def cas
    render json: { cas: Developer.find(params[:developer_id]).cas }
  end

  def parameterize
    render json: { custom_url: params[:company_name].parameterize }
  end

  def create
    if @developer.save
      @developer.clone_faqs
      BrandedAppHelper.create_destroy_actions(developer_params, @developer)

      redirect_to developers_path, notice: t(".success", developer_name: @developer.company_name)
    else
      @developer.build_address unless @developer.address
      render :new
    end
  end

  def update
    if @developer.update(developer_params)
      BrandedAppHelper.create_destroy_actions(developer_params, @developer)

      notice = Mailchimp::MailingListService.call(@developer)
      notice = t(".success", developer_name: @developer.company_name) if notice.nil?
      redirect_to developer_path(@developer), notice: notice
    else
      render :edit
    end
  end

  def destroy
    unless current_user.valid_password?(params[:password])
      alert = t("admin_permissable_destroy.incorrect_password", record: @developer)
      redirect_to developers_url, alert: alert
      return
    end

    @developer.destroy

    notice = t(".success", developer_name: @developer.company_name)
    redirect_to developers_url, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def developer_params
    params.require(:developer).permit(
      :country_id,
      :company_name, :custom_url, :email,
      :contact_number, :about,
      :api_key, :house_search, :enable_referrals,
      :enable_services, :development_faqs,
      :enable_roomsketcher, :enable_development_messages,
      :prime_lettings_admin, :personal_app, :cas, :timeline,
      :enable_perks,
      branded_perk_attributes: %i[id link account_number tile_image],
      address_attributes: %i[postal_number road_name building_name
                             locality city county postcode id]
    )
  end

  def default_tab
    return "developments" if !current_user.cf_admin? &&
                             @developer.divisions.empty?
    return "developments" if @developer.developments.present? &&
                             @developer.divisions.empty?
    "divisions"
  end
end
