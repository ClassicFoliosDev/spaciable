# frozen_string_literal: true

module FixfloPopulatorHelper
  require "uri"

  def maintenance_auto_populate(plot, current_resident)
    maintenance_link = plot.maintenance_link
    return maintenance_link unless plot.maintenance_auto_populate
    parameters = { "title" => current_resident.title, "firstname" => current_resident.first_name,
                   "surname" => current_resident.last_name, "email" => current_resident.email,
                   "contactno" => current_resident.phone_number,
                   "address.postcode" => plot.postcode, "address.town" => plot.city,
                   "address.addressline2" => plot.road_name,
                   "address.addressline1" => get_address(plot) }
    uri = URI.parse(maintenance_link).tap do |param|
      param.query = URI.encode_www_form(parameters)
    end
    uri.to_s
  end

  def get_address(plot)
    [plot.prefix, plot.postal_number, plot.building_name].compact.join(" ")
  end
end
