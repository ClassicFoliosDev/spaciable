# frozen_string_literal: true

# rubocop:disable all
module Living
  class Notification
    include HTTParty

    class << self
      def notify(notification, residents_in_scope)
        return if Rails.env.test?

        response = HTTParty.post("#{EnvVar[:living_api_url]}" +
                                  "#{EnvVar[:living_notification_webhook]}",
          body:
            {
              send_to_all: notification.send_to_all? ? "true" : "false",
              notification_id: notification.id,
              residency_ids: if notification.send_to_all?
                               []
                             else
                               PlotResidency.where(plot_id: notification.plot_ids)
                                            .where(resident_id: residents_in_scope.pluck(:id))
                                            .pluck(:id)
                             end
           }.to_json,
          headers:
            {
              "Content-Type" => "application/json",
              "Accept" => "application/json",
              "Authorization" => "Bearer #{EnvVar[:living_webhook_api_key]}"
            },
          timeout: 10)

          Rails.logger.error("ERROR: Failed to end Notification: #{response.message}") if response.code != 200
      rescue Net::OpenTimeout
        Rails.logger.error("ERROR: Timed out sending Notification: #{notification.id}")
      rescue => error
        Rails.logger.error("ERROR: Sending Notification: #{error.message}")
      end
    end
  end
end
