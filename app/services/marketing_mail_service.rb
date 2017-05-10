# frozen_string_literal: true
module MarketingMailService
  module_function

  def call(email, plot_residency, hooz_status, subscribed_status)
    # Temporary: will not be needed once we are storing the keys in the Hoozzi DB
    return unless Rails.application.secrets.mailchimp_key

    merge_fields = build_merge_fields(hooz_status, plot_residency)

    # Temporary, will move to developer field
    list_id = "91418e8697"

    client.lists(list_id).members(md5_hashed_email(email)).upsert(
      body: {
        email_address: email,
        status: subscribed_status,
        merge_fields: merge_fields
      }
    )
  end

  def build_merge_fields(hooz_status, plot_residency)
    return { HOOZSTATUS: hooz_status } unless plot_residency

    { HOOZSTATUS: hooz_status,
      FNAME: plot_residency.first_name,
      LNAME: plot_residency.last_name,
      CDATE: plot_residency.completion_date.to_s }
  end

  def md5_hashed_email(email)
    Digest::MD5.hexdigest(email.downcase)
  end

  def client
    Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_key)
  end
end
