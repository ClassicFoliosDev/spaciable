# frozen_string_literal: false

module Csv
  class CsvTransferService
    def self.call(csv_file, user)
      log_path = Rails.root.join("log", "csv_file_transfer.log")
      logger = Logger.new(log_path)

      if Rails.application.secrets.we_transfer_key.blank?
        logger.error("Unable to transfer file, no API key for transfer")
        return
      end

      transfer_url = transfer_csv(csv_file, user, logger)
      logger.info(transfer_url)

      transfer_url
    end

    def self.transfer_csv(csv_file, user, logger)
      @file_client = WeTransferClient.new(api_key: Rails.application.secrets.we_transfer_key)

      title = I18n.t("transfer_csv_title")
      description = I18n.t("transfer_csv_description")

      transfer = @file_client.create_transfer(name: title, description: description) do |upload|
        document_file_path = file_path(csv_file, tmp_folder(user.email), logger)
        upload.add_file_at(path: document_file_path)
      end

      transfer.shortened_url
    end

    def tmp_folder(email)
      hash = Digest::MD5.hexdigest(email)
      tmp_folder = Rails.root.join("tmp", hash)
      FileUtils.mkdir_p(tmp_folder) unless File.directory?(tmp_folder)

      hash
    end
  end
end
