# frozen_string_literal: true

class ExportAdminsJob < ApplicationJob
  queue_as :admin

  def perform(user, search_params)
    usearch = UserSearch.new(search_params)
    users = User.full_details({ per: 1000 },
                              Ability.new(user),
                              usearch)

    csv_file = Csv::ExportAdminsCsvService.call(users, search_params)

    # only process report with wetransfer if report returns any data
    # transfer_url = Csv::CsvTransferService.call(csv_file, user) if csv_file.readlines.size > 1
    byebug
    TransferCsvJob.perform_later(user.email, user.first_name, csv_file.to_s)
  end
end
