# frozen_string_literal: true
class Users::SessionsController < Devise::SessionsController
  layout -> { use_admin_layout? ? "admin_login" : "login" }

  skip_before_action :redirect_homeowners

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?

    if use_admin_layout?
      render "devise/admin/sessions/new"
    else
      @content = HomeownerLoginContentService.call
      respond_with(resource, serialize_options(resource))
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    @admin = current_user.cf_admin?
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def use_admin_layout?
    admin_pattern = /admin\Z/
    admin_session = cookies[:use_admin_layout].present?
    from_admin_path = request.path =~ admin_pattern || request.referer =~ admin_pattern

    if admin_session || from_admin_path
      cookies[:use_admin_layout] = "true"
      true
    else
      cookies.delete(:use_admin_layout)
      false
    end
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) do
        if @admin
          redirect_to new_admin_session_path
        else
          redirect_to new_user_session_path
        end
      end
    end
  end
end
