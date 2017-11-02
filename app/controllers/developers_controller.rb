# frozen_string_literal: true

class DevelopersController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :developer

  def index
    @developers = paginate(sort(@developers, default: :company_name))
  end

  def new
    @developer.build_address unless @developer.address
  end

  def edit
    @developer.build_address unless @developer.address
  end

  def show
    @active_tab = params[:active_tab] || "divisions"
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

  def create
    if @developer.save
      CloneDefaultFaqsJob.perform_later(faqable_type: "Developer", faqable_id: @developer.id)

      redirect_to developers_path, notice: t(".success", developer_name: @developer.company_name)
    else
      @developer.build_address unless @developer.address
      render :new
    end
  end

  def update
    if @developer.update(developer_params)
      notice = Mailchimp::MailingListService.call(@developer)
      notice = t(".success", developer_name: @developer.company_name) if notice.nil?
      redirect_to developer_path(@developer), notice: notice
    else
      render :edit
    end
  end

  def destroy
    @developer.destroy

    notice = t(".success", developer_name: @developer.company_name)
    redirect_to developers_url, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def developer_params
    params.require(:developer).permit(
      :company_name, :email,
      :contact_number, :about,
      :api_key, :house_search,
      address_attributes: %i[postal_number road_name building_name
                             locality city county postcode id]
    )
  end
end
