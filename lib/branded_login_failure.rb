# frozen_string_literal: true

class BrandedLoginFailure < Devise::FailureApp
  def redirect_url
    if RequestStore.store[:current_user].nil? &&
      RequestStore.store[:current_resident].nil?
      flash[:error] = "This account has been suspended...."
      new_user_session_path
    else
      URI(request.referer).path
    end
  end

  def respond
    if http_auth?
      http_auth
    elsif warden_options[:recall]
      recall
    else
      redirect_to new_resident_session_path
    end
  end
end
