# frozen_string_literal: false

module ServiceAssetHelper
  def service_image(service)
    service_name = service.category
    image_name = "service_#{service_name}.jpg"
    image_path(image_name)
  end
end
