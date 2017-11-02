# frozen_string_literal: true

class HowToSubCategoryController < ApplicationController
  load_and_authorize_resource :how_to_sub_category

  def list
    sub_categories = HowToSubCategory.where(parent_category: params[:option_name]).order(:name)

    render json: sub_categories
  end
end
