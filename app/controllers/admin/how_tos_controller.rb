# frozen_string_literal: true

module Admin
  class HowTosController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :how_to, :how_to_tag
    load_and_authorize_resource :tag, through: :how_to_tag

    # All the how_to views utilise @country in order to filter content etc
    # Set the country for index/new - country_id will be supplied as param
    before_action :set_country, only: %i[index new]
    # All update/show/edit and destroy will have country_id in their record
    # so just retrieve it using that
    before_action :find_country, only: %i[update show edit destroy]

    def index
      # Filter how_tos by country
      @how_tos = @how_tos.where(country: @country)
      @how_tos = @how_tos.includes(:how_to_tags, :tags)
      @how_tos = paginate(sort(@how_tos, default: { created_at: :desc }))
    end

    def new
      categories_and_tags
    end

    def create
      # Find the country by the code supplied in the params
      @country = Country.find_by(id: how_to_params[:country_id])

      if @how_to.save(how_to_params)
        @how_to.save_tags(how_to_params)
        @how_to.delete_duplicate_tags

        # Redirect to the how_tos for country
        redirect_to admin_how_tos_path(country: @country.name),
                    notice: t("controller.success.create", name: @how_to)
      else
        categories_and_tags
        render :new
      end
    end

    def update
      filtered_params = @how_to.save_tags(how_to_params)

      if @how_to.update(filtered_params)
        redirect_to admin_how_tos_path(country: @country.name),
                    notice: t("controller.success.update", name: @how_to)
      else
        render :edit
      end
    end

    def show; end

    def edit
      parent_category = t("activerecord.attributes.how_to.categories.#{@how_to.category}")
      @how_to_sub_categories = HowToSubCategory.where(parent_category: parent_category)
      @how_to.build_tags
    end

    def destroy
      @how_to.destroy
      notice = t("controller.success.destroy", name: @how_to)
      # Redirect to how tos for country
      redirect_to admin_how_tos_path(country: @country.name), notice: notice
    end

    def remove_tag
      tag_id = params[:tag]
      how_to_id = params[:how_to]

      @tag = Tag.find(tag_id)
      @how_to = HowTo.find(how_to_id)

      # Find the country now we have the how_to
      find_country

      # This will delete all joins between @tag and @how_to
      # if there is more than one
      if @how_to.tags.delete(@tag)
        notice = t(".success", how_to_name: @how_to.title, tag_name: @tag.name)
      end

      # Redirect to list
      redirect_to admin_how_tos_path(country: @country.name), notice: notice
    end

    private

    # The categories and tags are dependant on the country
    def categories_and_tags
      if @country.uk?
        @how_to_sub_categories = HowToSubCategory.where(
          parent_category: t("activerecord.attributes.how_to.categories.home")
        )
      elsif @country.spain?
        @how_to_sub_categories = HowToSubCategory.where(
          parent_category: t("activerecord.attributes.how_to.categories.buying")
        )
      end
      @how_to.build_tags
    end

    def how_to_params
      params.require(:how_to).permit(
        :title, :summary, :category,
        :description, :featured,
        :picture, :picture_cache,
        :remove_picture, :hide,
        :url, :additional_text,
        :how_to_sub_category_id,
        :country_id,
        tags_attributes: %i[id name _destroy]
      )
    end

    # This controller can get called without a :country parameter - specifically
    # for 'index' so has to set the default to Country.first if it's not been provided
    def set_country
      @country = params[:country] ? Country.find_by(name: params[:country]) : Country.first
    end

    # Find the country indicated by the country_id of the
    # current how_to record
    def find_country
      @country = Country.find_by(id: @how_to.country_id)
    end
  end
end
