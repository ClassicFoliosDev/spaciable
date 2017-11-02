# frozen_string_literal: false

module ResidentRouteHelper
  def resident_invitation_route(plot, token)
    token = token[:invitation_token] unless token.to_s == token

    path = build_path(plot)
    path << "/accept?"
    path << "invitation_token=#{token}"

    path
  end

  def resident_sign_in_route(plot)
    path = build_path(plot)
    path << "/sign_in"

    path
  end

  def build_path(plot)
    path = root_url

    path << plot.developer.to_s.parameterize
    path << "/#{plot.division.to_s.parameterize}" if plot.division
    path << "/#{plot.development.to_s.parameterize}"

    path
  end
end
