# frozen_string_literal: true

module Homeowners
  class VideosController < Homeowners::BaseController
    include TabsConcern

    def index
      @category = "videos"
      @categories = Document.categories.keys
      @videos = @plot&.development&.videos
      @videos = @videos.where("created_at <= ?", @plot.expiry_date) if @plot.expiry_date.present?

      redirect_to first_populated_tab_after(@category) if @videos.none?
    end
  end
end
