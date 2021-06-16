# frozen_string_literal: true

module NavigationHelper
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

  def area_guide_url(plot)
    return ENV.fetch("BA4M_EXPIRED_URL") if plot.expired?
    return ENV.fetch("BA4M_URL") if plot.postcode.blank?
    "#{ENV.fetch('BA4M_URL')}/area_guide/details/#{URI.encode(plot.postcode)}/wxwxwwx"
  end
end
