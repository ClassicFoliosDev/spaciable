# frozen_string_literal: true

module Admin
  class HowTosController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :how_to, :how_to_tag
    load_and_authorize_resource :tag, through: :how_to_tag

    def index
      @how_tos = @how_tos.includes(:how_to_tags, :tags)
      @how_tos = paginate(sort(@how_tos, default: { updated_at: :desc }))
    end

    def new
      categories_and_tags
    end

    def create
      if @how_to.save(how_to_params)
        @how_to.save_tags(how_to_params)
        @how_to.delete_duplicate_tags
        redirect_to admin_how_tos_path, notice: t("controller.success.create", name: @how_to)
      else
        categories_and_tags
        render :new
      end
    end

    def update
      filtered_params = @how_to.save_tags(how_to_params)

      if @how_to.update(filtered_params)
        redirect_to admin_how_tos_path, notice: t("controller.success.update", name: @how_to)
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
      redirect_to admin_how_tos_path, notice: notice
    end

    def remove_tag
      tag_id = params[:tag]
      how_to_id = params[:how_to]

      @tag = Tag.find(tag_id)
      @how_to = HowTo.find(how_to_id)

      # This will delete all joins between @tag and @how_to
      # if there is more than one
      if @how_to.tags.delete(@tag)
        notice = t(".success", how_to_name: @how_to.title, tag_name: @tag.name)
      end

      redirect_to admin_how_tos_path(@how_to), notice: notice
    end

    private

    def categories_and_tags
      @how_to_sub_categories = HowToSubCategory.where(
        parent_category: t("activerecord.attributes.how_to.categories.home")
      )
      @how_to.build_tags
    end

    def how_to_params
      params.require(:how_to).permit(
        :title, :summary, :category,
        :description, :featured,
        :picture, :picture_cache,
        :remove_picture,
        :url, :additional_text,
        :how_to_sub_category_id,
        tags_attributes: %i[id name _destroy]
      )
    end
  end
end
