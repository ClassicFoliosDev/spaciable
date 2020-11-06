# frozen_string_literal: true

module Homeowners
  class HowTosController < Homeowners::BaseController
    skip_before_action :validate_ts_and_cs, :set_plot, :set_brand,
                       unless: -> { current_resident || current_user }
    load_and_authorize_resource :how_to, except: %i[list_how_tos show_how_to]

    after_action only: %i[index] do
      category = I18n.t("activerecord.attributes.how_to.categories.#{@category}")
      record_event(:view_how_to,
                   category1: category,
                   category2: I18n.t("ahoy.#{Ahoy::Event::ROOT}",
                                     category: category))
    end

    after_action only: %i[show] do
      record_event(:view_how_to,
                   category1: I18n.t("activerecord.attributes.how_to.categories." \
                                     "#{@how_to.category}"),
                   category2: @how_to.title)
    end

    def index
      @category = how_to_params[:category]
      tag_id = how_to_params[:tag]

      # Populated categories associated with the country.  If there is a tag_id then
      # show all categories
      populate_categories(tag_id)

      @how_tos = tag_id ? process_tag(tag_id) : process_category

      # Redirect to next populated if empty && categories available
      redirect_to homeowner_how_tos_path(@categories.first) if !tag_id &&
                                                               @categories.any? &&
                                                               !@categories.include?(@category)
    end

    def list_how_tos
      # Set the default category according to country in case /homeowner/how_tos gets called
      # without a category
      category = @country.uk? ? :home : :buying
      category = params[:category] if params[:category]

      how_tos = HowTo.where(category: category).order(updated_at: :asc)

      render json: how_tos, status: 200
    end

    def show
      @others = HowTo.active.where(category: @how_to.category).where.not(id: @how_to.id)
    end

    def show_how_to
      @how_to = HowTo.find(params[:id])

      render json: @how_to, status: 200
    rescue ActiveRecord::RecordNotFound
      render json: "", status: 404
    end

    private

    def how_to_params
      params.permit(:category, :tag)
    end

    # Calculated the populated categories
    def populate_categories(tag_id)
      @categories = []
      @country = Country.find_by(name: "UK") if @country.nil?
      HowTo.country_categories(@country).each do |cat|
        @categories << cat if tag_id ||
                              @how_tos.active
                                      .where(category: cat)
                                      .includes(:how_to_tags)
                                      .order(created_at: :desc).any?
      end
    end

    # return the how_tos that match country/tags
    def process_tag(tag_id)
      @category = nil
      @tag = Tag.find(tag_id)
      @tag.how_tos.active
          .where(country_id: @country.id)
          .includes(:how_to_tags)
          .order(created_at: :desc)
    end

    def process_category
      @how_tos.active
              .where(category: @category)
              .includes(:how_to_tags)
              .order(updated_at: :desc)
    end
  end
end
