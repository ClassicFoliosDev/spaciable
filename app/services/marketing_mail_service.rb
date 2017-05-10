# frozen_string_literal: true
module MarketingMailService
  module_function

  def call(email, plot_residency, hooz_status, subscribed_status)
    merge_fields = build_merge_fields(hooz_status, plot_residency)

    MailchimpJob.perform_later("91418e8697",
                               email,
                               merge_fields,
                               subscribed_status)
  end

  def build_merge_fields(hooz_status, plot_residency)
    return { HOOZSTATUS: hooz_status } unless plot_residency

    { HOOZSTATUS: hooz_status,
      FNAME: plot_residency.first_name,
      LNAME: plot_residency.last_name,
      CDATE: plot_residency.completion_date.to_s }
  end
end
