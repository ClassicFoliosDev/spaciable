# frozen_string_literal: true

module Homeowners
  class CustomLinksController < Homeowners::BaseController
    def show
      redirect_to root_url unless params[:title]
      @formatted_link = format_link(params[:page])
    end

    private

    # iframe throws a routing error if the url does not begin with http:// or https://
    # add https:// to the beginning of the link if it does not have it
    def format_link(link)
      return "https://#{link}" if !(link =~ /\A(http)/)
      link
    end
  end
end
