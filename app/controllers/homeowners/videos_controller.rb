# frozen_string_literal: true
module Homeowners
  class VideosController < Homeowners::BaseController
    def index
      @categories = Document.categories.keys
      @videos = current_resident&.plot&.development&.videos
      @category = "videos"
    end
  end
end
