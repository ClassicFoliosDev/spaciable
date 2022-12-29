# frozen_string_literal: true

module Api
  class Prospect < ::Resident
    def send_devise_notification(_, *args)
      Api::ProspectMailer.invite(self, "Invitation instructions", args[0]).deliver_now
    end
  end
end
