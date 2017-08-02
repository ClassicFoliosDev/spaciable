# frozen_string_literal: true
class SitemapController < ActionController::Base
  def show
    render xml: File.read(Rails.root.join("public", "sitemap.xml"))
  end
end
