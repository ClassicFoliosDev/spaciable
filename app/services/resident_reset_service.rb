# frozen_string_literal: true

require "we_transfer_client"

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
    transfer_files(resident) if resident.private_documents.any?

    resident.developer_email_updates = false
    resident.isyt_email_updates = false
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

  def transfer_files(resident)
    return unless Rails.application.secrets.we_transfer_key

    @file_client = WeTransferClient.new(api_key: Rails.application.secrets.we_transfer_key)

    description = "Files from your closed account"
    @file_client.create_transfer(name: "Close account", description: description) do |upload|
      resident.private_documents.each do |document|
        upload.add_file_at(path: document.file.url)
      end
      upload.add_web_url(url: "https://hoozzi.wetransfer.com", title: "Hoozzi file transfers")
    end
  end
end
