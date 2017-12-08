# frozen_string_literal: true

module ResidentResetService
  module_function

  def reset_all_residents_for_plot(plot)
    return unless plot

    plot.residents.each do |resident|
      # Reset the resident settings if this is the last plot they are associated with
      reset_resident(resident, [plot.id]) if resident.plot_residencies.count == 1
    end
  end

  def reset_all_plots_for_resident(resident)
    reset_resident(resident, resident.plots.map(&:id))
  end

  def reset_resident(resident, plot_ids)
    resident.developer_email_updates = false
    resident.hoozzi_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save!

    response = ""
    plot_ids.each do |plot_id|
      plot_residency = PlotResidency.find_by(resident_id: resident.id, plot_id: plot_id)
      response = Mailchimp::MarketingMailService.call(resident,
                                                      plot_residency,
                                                      Rails.configuration.mailchimp[:unassigned])
    end

    response
  end
end
