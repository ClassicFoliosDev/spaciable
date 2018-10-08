# frozen_string_literal: true

module ResidentServicesService
  module_function

  def call(resident, service_ids, possible_old_services, plot)
    return unless resident
    return unless service_ids
    return unless plot.enable_services?

    new_service_names = update_services(resident, service_ids, possible_old_services)
    ServicesNotificationJob.perform_later(resident, new_service_names, plot)
    Mailchimp::MarketingMailService.update_services(resident, plot, service_ids)
  end

  private

  module_function

  def update_services(resident, service_ids, possible_old_services)
    # Make a list of previously selected services,
    # then clear them from the resident_services join table
    old_service_names = resident.services.map(&:to_s) if possible_old_services

    # Create a new join table entry for services subscribed now
    # Work out the delta between the services subscribed now and the ones that were
    # previously subscribed
    new_service_names = []
    service_ids.each do |id|
      ResidentService.create(resident_id: resident.id, service_id: id)
      service = Service.find(id)
      old_service_names.delete(service.to_s) if old_service_names&.include?(service.to_s)
      new_service_names << service.to_s
    end

    new_service_names
  end
end
