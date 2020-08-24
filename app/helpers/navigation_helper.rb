# frozen_string_literal: true

module NavigationHelper
  def build_services_params(current_resident, plot)
    # params for referral link
    return unless current_resident
    name = [current_resident.first_name, current_resident.last_name].compact.join(" ")
    email = current_resident.email
    phone = current_resident&.phone_number
    developer = plot.developer
    "?sf_name=#{name}&sf_email=#{email}&sf_telephone=#{phone}&sf_developer=#{developer}"
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

  # Build a shortcut link.  Shortcut links can be specified as urls .. 'http..etc' or they can
  # be defined in terms of internal rails routes e.g services_path.  Some of the internal rails
  # paths need further expansion to include the homeowner details.  If the link is a rails path
  # i.e. services_path, then check for a matching 'build' function i.e build_services_path
  # that can add the required query parameters for the current resident
  # rubocop:disable Security/Eval
  def build_shortcut(shortcut, resident, plot)
    return shortcut if shortcut.start_with?("http")

    build = "build_#{shortcut.chomp('_path')}_params"
    query_params = (send(build, resident, plot) if respond_to?(build)) || ""

    (ENV[shortcut.upcase] || eval(shortcut)) + query_params
  end
  # rubocop:enable Security/Eval

  # external links

  def area_guide_url
    ENV.fetch("BA4M_URL")
  end
end
