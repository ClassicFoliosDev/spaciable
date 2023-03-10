# frozen_string_literal: false

module PlotRouteHelper
  def resident_invitation_route(plot, token)
    token = token[:invitation_token] unless token.to_s == token

    return create_living_resident(plot, token) if plot.platform_is?(:living)

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
    root_url << plot.custom_url
  end

  def create_living_resident(plot, token)
    path = EnvVar[:create_living_resident].gsub("INVITATION_TOKEN", token)
    path << "&brand_id=#{plot.brand.id}" if plot.brand.id.present?

    Firebase.shorten(path) do |short_url, error|
      path = short_url if error.blank?
    end

    path
  end

  def resident_edit_password_route(resource, token)
    if RequestStore.store[:living_req].blank?
      return edit_password_url(@resource, reset_password_token: @token)
    end

    path = EnvVar[:living_password_reset].gsub("RESET_PASSWORD_TOKEN", token)
    plots = resource.plots
    if plots.count == 1 && plots.first.brand.id.present?
      path << "&brand_id=#{plots.first.brand.id}"
    end

    Firebase.shorten(path) do |short_url, error|
      path = short_url if error.blank?
    end

    path
  end
end
