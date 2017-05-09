# frozen_string_literal: true
module Residents
  class InvitationsController < Devise::InvitationsController
    layout "accept"
  end
end
