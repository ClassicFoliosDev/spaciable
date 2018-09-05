# frozen_string_literal: true

require "we_transfer_client"

module ResidentResetService
  module_function

  def reset_all_residents_for_plot(reset_plot)
    return unless reset_plot

    reset_plot.residents.each do |resident|
      transfer_files_and_notify(resident, reset_plot) if resident.private_documents.any?
      # Reset the resident settings if this is the last plot they are associated with
      reset_resident(resident) if resident.plot_residencies.count == 1
    end
  end

  def reset_all_plots_for_resident(resident)
    transfer_files_and_notify(resident, nil) if resident.private_documents.any?
    reset_resident(resident)
  end

  def transfer_files_and_notify(resident, reset_plot)
    transfer_url = transfer_private_files(resident, reset_plot)

    TransferFilesJob.perform_later(resident.email, resident.to_s,
                                   transfer_url, plots_string(resident, reset_plot))
  end

  def plots_string(resident, reset_plot)
    return reset_plot&.to_homeowner_s if reset_plot.present?

    # In practice, there will only be a single plot here
    resident&.plots&.last&.to_homeowner_s
  end

  def reset_resident(resident)
    update_resident_params(resident)
    CloseAccountJob.perform_later(resident.email, resident.to_s)
    update_mailchimp(resident)
  end

  def update_mailchimp(resident)
    response = ""

    resident.plots.each do |plot|
      response = Mailchimp::MarketingMailService.call(resident,
                                                      plot,
                                                      Rails.configuration.mailchimp[:unassigned])
    end

    response
  end

  def update_resident_params(resident)
    resident.developer_email_updates = false
    resident.hoozzi_email_updates = false
    resident.telephone_updates = false
    resident.post_updates = false
    resident.save(validate: false)
  end

  def transfer_private_files(resident, reset_plot)
    log_path = Rails.root.join("log", "closing_file_transfer.log")
    logger = Logger.new(log_path)
    logger.info("==== Resident #{resident.email} ====")

    if Rails.application.secrets.we_transfer_key.blank?
      logger.error("Unable to transfer files, no API key for transfer")
      return
    end

    transfer_url = transfer_files(resident, reset_plot, logger)
    logger.info(transfer_url)

    transfer_url
  end

  def transfer_files(resident, reset_plot, logger)
    @file_client = WeTransferClient.new(api_key: Rails.application.secrets.we_transfer_key)

    title = I18n.t("transfer_files_title")
    description = I18n.t("transfer_files_description")

    transfer = @file_client.create_transfer(name: title, description: description) do |upload|
      resident_private_documents(resident, reset_plot).each do |document|
        next unless document.file
        next if document.file.size.zero?

        document_file_path = file_path(document, tmp_folder(resident.email), logger)
        upload.add_file_at(path: document_file_path)
        remove_document_from_plot(document, reset_plot)
      end
    end

    transfer.shortened_url
  end

  # This will happen automatically through the model dependencies if a resident is deleted
  # entirely, but is needed in the scenario where a resident is removed from a single plot
  def remove_document_from_plot(document, reset_plot)
    if reset_plot.nil? || document.plots.empty?
      document.destroy
    else
      document.plots.delete(reset_plot)
      document.destroy if document.plots.empty?
    end
  end

  def resident_private_documents(resident, reset_plot)
    return resident.private_documents.where(plot_id: reset_plot.id) if reset_plot

    # If you get here, the resident has no more plots and is being removed from Hoozzi.
    # In most valid code paths, there will only be a single plot left by now, but it's
    # still important that we query all private documents here, to cover there case where
    # there are legacy private documents that have no plot id associated

    resident.private_documents.all
  end

  def tmp_folder(email)
    # The file has the name "mini_magic_<timestamp>" by default, so we need to save it with
    # a more user friendly name, reusing the original file name. File names are not guaranteed
    # unique, so for safety create a temp folder to store it in

    hash = Digest::MD5.hexdigest(email)
    tmp_folder = Rails.root.join("tmp", hash)
    FileUtils.mkdir_p(tmp_folder) unless File.directory?(tmp_folder)

    hash
  end

  def file_path(document, hash, logger)
    temp_file = MiniMagick::Image.open(document.file.url)
    cloned_file = temp_file.clone
    document_long_name = document.file.url.split("file/#{document.id}/").last
    document_name = document_long_name.split("?X-Amz-Algorithm").first

    save_path = Rails.root.join("tmp", hash, document_name)
    cloned_file.write(save_path)

    logger.info("Transferring #{save_path}")
    save_path
  end
end
