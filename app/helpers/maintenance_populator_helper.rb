# frozen_string_literal: true

module MaintenancePopulatorHelper
  require "uri"

  def maintenance_auto_populate(plot, current_resident)
    maintenance_link = plot.maintenance.path
    return maintenance_link unless plot.maintenance.populate

    parameters = if plot.maintenance.clixifix?
                   clixifix_auto_populate(plot, current_resident, maintenance_link)
                 else
                   fixflo_auto_populate(plot, current_resident)
                 end

    uri = URI.parse(maintenance_link).tap do |param|
      param.query = URI.encode_www_form(parameters)
    end
    uri.to_s
  end

  def fixflo_auto_populate(plot, current_resident)
    {
      "title" => current_resident&.title, "firstname" => current_resident&.first_name,
      "surname" => current_resident&.last_name, "email" => current_resident&.email,
      "contactno" => current_resident&.phone_number,
      "address.postcode" => plot.postcode, "address.town" => plot.city,
      "address.addressline2" => plot.road_name,
      "address.addressline1" => get_address(plot)
    }
  end

  def clixifix_auto_populate(plot, current_resident, maintenance_link)
    {
      "Address.AddressLine1" => get_address(plot), "Address.AddressLine2" => plot.road_name,
      "Address.PostCode" => plot.postcode, "Address.Town" => plot.city,
      "ClientId" => clixifix_client_id(maintenance_link),
      "Contact.FirstName" => current_resident&.first_name,
      "Contact.Surname" => current_resident&.last_name,
      "Contact.Telephone" => current_resident&.phone_number,
      "Contact.Title" => current_resident&.title&.capitalize, "development" => plot.development,
      "portal" => "spaciable"
    }
  end

  def clixifix_client_id(maintenance_link)
    CGI.parse(URI.parse(maintenance_link).query)["ClientId"]
  end

  def get_address(plot)
    [plot.prefix, plot.postal_number, plot.building_name].compact.join(" ")
  end
end
