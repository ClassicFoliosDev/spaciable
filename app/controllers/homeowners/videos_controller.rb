# frozen_string_literal: true

module Homeowners
  class VideosController < Homeowners::BaseController
    include TabsConcern

    def index
      @category = "videos"
      @categories = Document.categories.keys
      @videos = @plot&.development&.videos || []

      redirect_to first_populated_tab_after(@category) if @videos.none?
    end
  end
end
