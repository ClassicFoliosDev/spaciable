# frozen_string_literal: true
module MarketingMailService
  module_function

  def call(plot_residency, status)
    response = test_list.members(md5_hashed_email(plot_residency.email)).upsert(
      body: {
        email_address: plot_residency.email,
        status: "subscribed",
        merge_fields: {HOOZSTATUS: status, FNAME: plot_residency.first_name, WRONG: plot_residency.last_name}
      }
    )
  end

  def md5_hashed_email(email)
    Digest::MD5.hexdigest(email.downcase)
  end

  def test_list
    client.lists("91418e8697")
  end

  def client
    Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_key, symbolize_keys: true)
  end
end

