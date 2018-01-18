# frozen_string_literal: true

namespace :ts_and_cs do
  desc "Reset the ts and cs status for all residents"
  task reset: :environment do
    log_file = "log/reset_ts_and_cs.log"
    logger = Logger.new log_file

    logger.info(">>>>>>>> Reset terms and conditions status for all residents <<<<<<<<")
    logger.info(Time.zone.now)

    count = 0

    ActiveRecord::Base.transaction do
      Resident.find_each do |resident|
        count += 1

        resident.update_attribute(:ts_and_cs_accepted_at, nil)
      end
    end

    logger.info("Ts and Cs cookie will be removed on next log in for each homeowner")
    logger.info(">>>>>>>> Reset completed for #{count} residents <<<<<<<<")
  end
end
