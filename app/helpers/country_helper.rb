# frozen_string_literal: true

module CountryHelper
  include TabsHelper

  # Build tabs for all the countries in the Country table
  def country_tabs(active)
    tabs = []
    Country.all.each do |country|
      tabs << [country.name, "flag", admin_how_tos_path(country: country.name), country == active]
    end

    tabs
  end

  # Get the Countries
  def country_collection
    collection = []
    Country.all.each { |c| collection << [c.name, c.id] }
    collection
  end
end
