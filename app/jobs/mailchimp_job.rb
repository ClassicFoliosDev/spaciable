# frozen_string_literal: true
class MailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(list_id, email, merge_fields)
    client.lists(list_id).members(md5_hashed_email(email)).upsert(
      body: {
        email_address: email,
        status: "subscribed",
        merge_fields: merge_fields
      }
    )
  end

  private

  def md5_hashed_email(email)
    Digest::MD5.hexdigest(email.downcase)
  end

  def client
    Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_key, symbolize_keys: true)
  end
end
