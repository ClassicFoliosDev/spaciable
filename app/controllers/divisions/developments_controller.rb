# frozen_string_literal: true

module Divisions
  # rubocop:disable Metrics/ClassLength
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :division
    load_resource :development, through: :division

    def index
      @developments = paginate(sort(@developments, default: :name))
    end

    def new
      @development.build
      @development.cas = @development.parent_developer.cas
    end

    def edit
      @development.build
    end

    def show
      @selected_tab = params[:active_tab]
      @active_tab = @selected_tab || "phases"

      @collection = if @active_tab == "unit_types"
                      paginate(sort(@development.unit_types, default: :name))
                    elsif @active_tab == "phases"
                      paginate(sort(@development.phases, default: :number))
                    elsif @active_tab == "choice_configurations"
                      paginate(sort(@development.choice_configurations, default: :name))
                    elsif @active_tab == "documents"
                      documents = @development.documents.accessible_by(current_ability)
                      paginate(sort(documents, default: :title))
                    end
    end

    def create
      if @development.save
        clone_default_faqs if @development.development_faqs
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@division, :developments], notice: notice
      else
        @development.build
        render :new
      end
    end

    def update
      if @development.update(development_params)
        update_my_home
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@division, @development], notice: notice
      else
        @development.build
        render :new
      end
    end

    def destroy
      unless current_user.valid_password?(params[:password])
        alert = t("admin_permissable_destroy.incorrect_password", record: @development)
        redirect_to division_developments_path, alert: alert
        return
      end

      @development.destroy

      notice = t(".success", development_name: @development.name)
      redirect_to division_developments_path, notice: notice
    end

    private

    def update_my_home
      @development.update(construction_name: nil) if @development.residential?
    end

    def development_params
      params.require(:development).permit(
        :name, :choice_option,
        :analytics_dashboard, :choices_email_contact,
        :division_id, :email, :contact_number,
        :enable_snagging, :snag_duration, :snag_name, :cas, :calendar, :conveyancing,
        :construction, :construction_name, :client_platform,
        maintenance_attributes: %i[id path account_type populate fixflow_direct],
        premium_perk_attributes: %i[id enable_premium_perks premium_licences_bought
                                    premium_licence_duration],
        address_attributes: %i[postal_number road_name building_name
                               locality city county postcode],
        material_info_attributes: material_info_attributes
      )
    end

    # rubocop:disable Metrics/MethodLength
    def material_info_attributes
      [
        :id,
        :proliferate,
        :selling_price,
        :reservation_fee,
        :tenure,
        :lease_length,
        :service_charges,
        :council_tax_band,
        :property_type,
        :floor,
        :floorspace,
        :estimated_legal_completion_date,
        :epc_rating,
        :property_construction,
        :property_construction_other,
        :electricity_supply,
        :electricity_supply_other,
        :water_supply,
        :sewerage,
        :sewerage_other,
        :broadband,
        :mobile_signal,
        :mobile_signal_restrictions,
        :parking,
        :building_safety,
        :restrictions,
        :rights_and_easements,
        :flood_risk,
        :planning_permission_or_proposals,
        :accessibility,
        :coalfield_or_mining_areas,
        :other_considerations,
        :warranty_num,
        :mprn,
        :mpan,
        heating_fuel_ids: [],
        heating_source_ids: [],
        heating_output_ids: []
      ]
    end
    # rubocop:enable Metrics/MethodLength

    def clone_default_faqs
      developer = Developer.find_by(id: @division.developer_id)
      CloneDefaultFaqsJob.perform_later(faqable_type: "Development",
                                        faqable_id: @development.id,
                                        country_id: developer.country)
    end
  end
  # rubocop:enable Metrics/ClassLength
end
