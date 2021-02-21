# frozen_string_literal: true

module Divisions
  class DevelopmentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :division
    load_and_authorize_resource :development, through: :division

    def index
      @developments = paginate(sort(@developments, default: :name))
    end

    def new
      @development.build(:address)
      @maintenance = Maintenance.new
      @development.build(:maintenance)
      @development.cas = @development.parent_developer.cas
      @premium_perk = PremiumPerk.new
      @development.build(:premium_perk)
    end

    def edit
      @development.build(:address)
      @development.build(:maintenance)
      @development.build(:premium_perk)
    end

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
                    end
    end

    def create
      if @development.save
        clone_default_faqs if @development.development_faqs
        notice = Mailchimp::SegmentService.call(@development)
        notice = t(".success", development_name: @development.name) if notice.nil?
        redirect_to [@division, :developments], notice: notice
      else
        @development.build(:address)
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
        @development.build(:address)
        render :edit
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
      @development.update_attributes(construction_name: nil) if @development.residential?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  def development_params
      params.require(:development).permit(
        :name, :choice_option,
        :division_id,
        :email, :contact_number,
        :enable_snagging, :snag_duration, :snag_name, :cas, :calendar, :conveyancing,
        :construction, :construction_name,
        maintenance_attributes: %i[id path account_type populate],
        premium_perk_attributes: %i[id enable_premium_perks premium_licences_bought
                                    premium_licence_duration],
        address_attributes: %i[postal_number road_name building_name
                               locality city county postcode]
      )
    end

    def clone_default_faqs
      developer = Developer.find_by(id: @division.developer_id)
      CloneDefaultFaqsJob.perform_later(faqable_type: "Development",
                                        faqable_id: @development.id,
                                        country_id: developer.country)
    end
  end
end
