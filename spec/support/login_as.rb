# frozen_string_literal: true

module LoginAs
  def login_as(user, opts = {})
    $current_user = user
    opts.reverse_merge!(scope: user&.model_name&.element)

    Warden.on_next_request do |proxy|
      opts[:event] ||= :authentication
      proxy.set_user(user, opts)
    end
  end
end
