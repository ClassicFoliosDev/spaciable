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
    log_path = Rails.root.join("log", "closing_file_transfer.log")
    logger = Logger.new(log_path)
    logger.info("==== Resident #{resident.email} ====")

    if Rails.application.secrets.we_transfer_key.blank?
      logger.error("Unable to transfer files, no API key for transfer")
      return
    end

    transfer_url = transfer_files(resident, logger)
    logger.info(transfer_url)
  end

  def transfer_files(resident, logger)
    @file_client = WeTransferClient.new(api_key: Rails.application.secrets.we_transfer_key)

    name = resident.to_s
    description = I18n.t("close_account_files_description")
    hash = tmp_folder(resident.email)

    transfer = @file_client.create_transfer(name: name, description: description) do |upload|
      resident.private_documents.each do |document|
        cloned_file_path = file_path(document, hash, logger)
        upload.add_file_at(path: cloned_file_path)
      end
      upload.add_web_url(url: "https://wetransfer.com", title: I18n.t("file_transfer"))
    end

    transfer.shortened_url
  end

  def tmp_folder(email)
    # The file will be stored as "mini_magic_<timestamp>" by default, so we need to save it with
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

    logger.info("Transferring #{cloned_file.path}")
    cloned_file.path
  end
end
