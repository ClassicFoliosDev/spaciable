# frozen_string_literal: true

# rubocop:disable all
module Living
  class AdminNotification
    include HTTParty

    class << self
      def notify(notification)
        return if Rails.env.test?
        byebug

        response = HTTParty.post("#{EnvVar[:living_api_url]}" +
                                  "#{EnvVar[:living_admin_notification_webhook]}",
          body:
            {
              admin_notification_id: notification.id
           }.to_json,
          headers:
            {
              "Content-Type" => "application/json",
              "Accept" => "application/json",
              "Authorization" => "Bearer #{EnvVar[:living_webhook_api_key]}"
            },
          timeout: 10)

          Rails.logger.error("ERROR: Failed to send Admin Notification: #{response.message}") if response.code != 200
      rescue Net::OpenTimeout
        Rails.logger.error("ERROR: Timed out sending Admin Notification: #{notification.id}")
      rescue => error
        Rails.logger.error("ERROR: Sending Admin Notification: #{error.message}")
      end
    end
  end
end
