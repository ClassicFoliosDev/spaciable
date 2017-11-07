# frozen_string_literal: true

module ResidentServicesService
  module_function

  def call(resident, service_ids, possible_old_services)
    # Remove all existing resident services
    if possible_old_services
      old_service_names = resident.services.map(&:name)
      resident.services.delete_all
    end

    service_ids.each do |id|
      ResidentService.create(resident_id: resident.id, service_id: id)
      service = Service.find(id)
      old_service_names.delete(service.name) if old_service_names&.include?(service.name)
    end

    ServicesNotificationJob.perform_later(resident, old_service_names)
    service_ids.length
  end
end
