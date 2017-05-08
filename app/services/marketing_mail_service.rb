# frozen_string_literal: true
module MarketingMailService
  module_function

  def call(plot_residency, status)
    MailchimpJob.perform_later("91418e8697", plot_residency.email, {
      HOOZSTATUS: status,
      FNAME: plot_residency.first_name,
      LNAME: plot_residency.last_name}
    )
  end
end
