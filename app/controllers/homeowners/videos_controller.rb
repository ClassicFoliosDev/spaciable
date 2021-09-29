# frozen_string_literal: true

module Homeowners
  class VideosController < Homeowners::BaseController
    include TabsConcern

    after_action only: %i[index] do
      unless @videos.none?
        record_event(:view_library,
                     category1: t("components.homeowner.library_categories.videos"))
      end
    end

    def index
      @category = "videos"
      @categories = Document.categories.keys
      @videos = @plot&.videos

      redirect_to first_populated_tab_after(@category) if @videos.none?
    end
  end
end
