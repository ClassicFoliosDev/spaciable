# frozen_string_literal: true
module UpdateUserService
  module_function

  def call(user, user_params)
    result = if user_params[:password]&.present?
               user.update_with_password(user_params)
             else
               user_params.delete(:current_password)
               user.update_without_password(user_params.except(:current_password))
             end

    if result
      user.send_password_change_notification if user_params[:password].present?
    end

    result
  end
end
