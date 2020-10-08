# frozen_string_literal: false

module PlotRouteHelper
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
    root_url << plot.development.id.to_s
  end
end
