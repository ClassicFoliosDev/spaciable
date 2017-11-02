# frozen_string_literal: true

module Homeowners
  class VideosController < Homeowners::BaseController
    def index
      @categories = Document.categories.keys
      @videos = @plot&.development&.videos || []
      @category = "videos"
    end
  end
end
