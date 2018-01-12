# frozen_string_literal: true

module ResidentResetService
  module_function

  def reset_all_residents_for_plot(plot)
    return unless plot

    plot.residents.each do |resident|
      # Reset the resident settings if this is the last plot they are associated with
      reset_resident(resident, [plot]) if resident.plot_residencies.count == 1
    end
  end

  def reset_all_plots_for_resident(resident)
    reset_resident(resident, resident.plots)
  end

  def reset_resident(resident, plots)
    resident.developer_email_updates = false
    resident.hoozzi_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save(validate: false)

    response = ""
    plots.each do |plot|
      response = Mailchimp::MarketingMailService.call(resident,
                                                      plot,
                                                      Rails.configuration.mailchimp[:unassigned])
    end

    response
  end
end
