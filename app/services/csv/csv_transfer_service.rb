# frozen_string_literal: false

require "we_transfer_client"

module Csv
  class CsvTransferService
    def self.call(csv_files, user)
      log_path = Rails.root.join("log", "csv_file_transfer.log")
      logger = Logger.new(log_path)
      if Rails.application.secrets.we_transfer_key.blank?
        logger.error("Unable to transfer file, no API key for transfer")
        return
      end

      transfer_url = transfer_csvs(csv_files, user, logger)
      logger.info(transfer_url)

      transfer_url
    end

    def self.transfer_csvs(csv_files, user, logger)
      client = WeTransfer::Client.new(api_key: Rails.application.secrets.we_transfer_key)
      description = I18n.t("transfer_csv_description")

      transfer = client.create_transfer_and_upload_files(message: description) do |upload|
        csv_files.each do |csv_file|
          document_file_path = file_path(csv_file, tmp_folder(user.email), logger)
          upload.add_file_at(path: document_file_path)
        end
      end

      transfer.url
    end

    def self.tmp_folder(email)
      hash = Digest::MD5.hexdigest(email)
      tmp_folder = Rails.root.join("tmp", hash)
      FileUtils.mkdir_p(tmp_folder) unless File.directory?(tmp_folder)

      hash
    end

    def self.file_path(csv_file, hash, logger)
      save_path = Rails.root.join("tmp", hash, csv_file.basename.to_s)
      FileUtils.cp(csv_file.to_s, save_path)

      logger.info("Transferring #{save_path}")
      save_path
    end
  end
end
