# frozen_string_literal: true
class BrandedLoginFailure < Devise::FailureApp
  def redirect_url
    URI(request.referer).path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
