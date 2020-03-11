# frozen_string_literal: true

module Developers
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :developer
    load_and_authorize_resource :development, through: [:developer]

    def index
      @developments = paginate(sort(@developments, default: :name))
    end

    # rubocop:disable Metrics/AbcSize
    def show
      @active_tab = params[:active_tab] || "phases"

      @collection = if @active_tab == "unit_types"
                      paginate(sort(@development.unit_types, default: :name))
                    elsif @active_tab == "phases"
                      paginate(sort(@development.phases, default: :number))
                    elsif @active_tab == "choice_configurations"
                      paginate(sort(@development.choice_configurations, default: :name))
                    elsif @active_tab == "documents"
                      documents = @development.documents.accessible_by(current_ability)
                      paginate(sort(documents, default: :title))
                    # Can only get here in test env
                    elsif @active_tab == "plots"
                      @development.plots
                    end
    end
    # rubocop:enable Metrics/AbcSize

    def new
      @development.build_address unless @development.address
      @maintenance = Maintenance.new
      @development.build_maintenance unless @development.maintenance
      @premium_perk = PremiumPerk.new
      @development.build_premium_perk unless @development.premium_perk
    end

    def edit
      @development.build_address unless @development.address
      @development.build_maintenance unless @development.maintenance
      @development.build_premium_perk unless @development.premium_perk
    end

    def create
      if @development.save
        if @development.development_faqs
          CloneDefaultFaqsJob.perform_later(faqable_type: "Development",
                                            faqable_id: @development.id,
                                            country_id: @developer.country_id)
        end
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@developer, :developments], notice: notice
      else
        @development.build_address unless @development.address
        render :new
      end
    end

    def update
      if @development.update(development_params)
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@developer, @development], notice: notice
      else
        @development.build_address unless @development.address
        render :edit
      end
    end

    def destroy
      notice = t(".success", development_name: @development.name)

      @development.destroy
      redirect_to [@developer, :developments], notice: notice
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def development_params
      params.require(:development).permit(
        :name, :choice_option,
        :choices_email_contact,
        :developer_id, :division_id,
        :email, :contact_number,
        :enable_snagging, :snag_duration, :snag_name,
        maintenance_attributes: %i[id path account_type populate],
        premium_perk_attributes: %i[id enable_premium_perks premium_licences_bought
                                    premium_licence_duration],
        address_attributes: %i[postal_number road_name building_name
                               locality city county postcode]
      )
    end
  end
end
