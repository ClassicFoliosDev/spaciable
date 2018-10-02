# frozen_string_literal: true

module ResidentServicesService
  module_function

  def call(resident, service_ids, possible_old_services, plot)
    return unless resident
    return unless service_ids
    return unless plot.enable_services?

    old_service_names = update_services(resident, service_ids, possible_old_services)
    ServicesNotificationJob.perform_later(resident, old_service_names, plot)
    Mailchimp::MarketingMailService.update_services(resident, plot, service_ids)
  end

  private

  module_function

  def update_services(resident, service_ids, possible_old_services)
    # Make a list of previously selected services,
    # then clear them from the resident_services join table
    if possible_old_services
      old_service_names = resident.services.map(&:name)
      resident.services.delete_all
    end

    # Create a new join table entry for services subscribed now
    # Work out the delta between the services subscribed now and the ones that were
    # previously subscribed
    service_ids.each do |id|
      ResidentService.create(resident_id: resident.id, service_id: id)
      service = Service.find(id)
      old_service_names.delete(service.name) if old_service_names&.include?(service.name)
    end

    old_service_names
  end
end
