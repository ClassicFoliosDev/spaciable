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

  def allocate_perk_type(current_resident, plot)
    return unless current_resident
    # if Premium is available on the plot for the current resident
    if Vaboo.premium_perks_available?(current_resident, plot)
      # has the plot reached legal completion?
      if plot.completed?
        # if another resident on the plot has activated Premium
        if Vaboo.premium_perks_activated?(plot)
          "basic"
        # if no other resident on the plot has activated Premium
        else
          "premium"
        end
      # if Premium is available on the plot but the plot has not reached legal completion
      else
        "coming_soon"
      end
    # if Premium is not available on the plot regardless if the plot has reached legal completion
    else
      "basic"
    end
  end
end
