# frozen_string_literal: true

module LoginAs
  def login_as(user, opts = {})
    $current_user = user
    RequestStore.store[:current_user] = $current_user unless user.is_a? Resident

    opts.reverse_merge!(scope: user&.model_name&.element)

    Warden.on_next_request do |proxy|
      opts[:event] ||= :authentication
      proxy.set_user(user, opts)
    end
  end
end
