# frozen_string_literal: true

module NavigationHelper
  def build_services_params(current_resident, plot)
    # params for referral link
    return unless current_resident
    name = [current_resident.first_name, current_resident.last_name].compact.join(" ")
    email = current_resident.email
    phone = current_resident&.phone_number
    developer = plot.developer
    return "?sf_name=#{name}&sf_email=#{email}&sf_telephone=#{phone}&sf_developer=#{developer}"
  end
end
