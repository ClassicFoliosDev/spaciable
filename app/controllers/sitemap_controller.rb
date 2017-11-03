# frozen_string_literal: true

class SitemapController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def show
    render xml: File.read(Rails.root.join("public", "sitemap.xml"))
  end
end
