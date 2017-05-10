# frozen_string_literal: true
class MailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(list_id, email, merge_fields, subscribe_status)
    client.lists(list_id).members(md5_hashed_email(email)).upsert(
      body: {
        email_address: email,
        status: subscribe_status,
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
