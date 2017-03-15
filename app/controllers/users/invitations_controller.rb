# frozen_string_literal: true
module Users
  class InvitationsController < Devise::InvitationsController
    layout "admin_login"
  end
end
