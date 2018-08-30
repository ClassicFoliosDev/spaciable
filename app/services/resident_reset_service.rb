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
    transfer_private_files(resident) if resident.private_documents.any?
    update_resident_params(resident)
    update_mailchimp(resident, plots)
  end

  def update_mailchimp(resident, plots)
    response = ""
    plots.each do |plot|
      response = Mailchimp::MarketingMailService.call(resident,
                                                      plot,
                                                      Rails.configuration.mailchimp[:unassigned])
    end

    response
  end

  def update_resident_params(resident)
    resident.developer_email_updates = false
    resident.isyt_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save(validate: false)
  end

  def transfer_private_files(resident)
    sent_file_url = transfer_files(resident)

    log_path = Rails.root.join("log", "closing_file_transfer.log")
    logger = Logger.new(log_path)
    logger.info("==== Resident #{resident.email} ====")
    logger.info("Transferred #{resident.private_documents.count} files to")
    logger.info(sent_file_url)
  end

  def transfer_files(resident)
    return unless Rails.application.secrets.we_transfer_key

    @file_client = WeTransferClient.new(api_key: Rails.application.secrets.we_transfer_key)

    name = "Close account"
    description = "Files from your closed account"
    transfer = @file_client.create_transfer(name: name, description: description) do |upload|
      resident.private_documents.each do |document|
        temp_file = MiniMagick::Image.open(document.file.url)
        upload.add_file_at(path: temp_file.path)
      end
      upload.add_web_url(url: "https://hoozzi.wetransfer.com", title: "Hoozzi file transfers")
    end

    transfer.shortened_url
  end
end
