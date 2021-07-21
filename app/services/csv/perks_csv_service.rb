# frozen_string_literal: true

module Csv
  class PerksCsvService
    # constants
    ACCESS_KEY = ENV.fetch("VABOO_ACCESS")
    URL = ENV.fetch("VABOO_APP_URL")
    ACCOUNT_ID = ENV.fetch("VABOO_ACCOUNT")
    API = "/api/v4/"

    def self.call(report)
      filename = build_filename("perks_summary")
      path = init(report, filename)

      # check the spaciable perks portal and each of the branded perks portals
      # create an array of account numbers
      account_ids = [ACCOUNT_ID]
      BrandedPerk.all.each do |bp|
        account_ids << bp.account_number if bp.account_number
      end

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        find_each_perk_account(account_ids, csv)
      end

      path
    end

    # iterate over each account number to access the perks account,
    # i.e. get spaciable branded, then each developer branded
    def self.find_each_perk_account(account_ids, csv)
      account_ids.each do |id|
        full_url = "#{URL}#{API}users/#{id}/#{ACCESS_KEY}"
        response = HTTParty.get(full_url)
        next unless response.code == 200

        parsed_response = JSON.parse(response)
        add_residents(parsed_response, csv)
      end
    end

    def self.add_residents(parsed_response, csv)
      parsed_response["data"]["users"].each do |user|
        resident = Resident.find_by(email: user[Vaboo::EMAIL])

        # find the plot from which they activated perks
        plot = Plot.find_by(id: user[Vaboo::REFERENCE])

        csv << resident_info(user, plot, resident) if plot && resident && within_date(user)
      end
    end

    def self.resident_info(user, plot, resident)
      [
        plot.account_manager_name,
        plot.company_name, plot_division(plot), plot.development_name,
        plot.phase.to_s, plot.number,
        resident.first_name, resident.last_name, resident.email, resident.phone_number,
        user[Vaboo::ACCESS_TYPE],
        plot.premium_licence_duration,
        user[Vaboo::START]
      ]
    end

    def self.within_date(user)
      # did the resident create their account within the selected date range?
      user[Vaboo::START].between?(@from, @to)
    end

    def self.init(report, filename)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      formatted_from = I18n.l(@from.to_date, format: :digits)
      formatted_to = I18n.l(@to.to_date, format: :digits)

      Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
    end

    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)

      "#{now}_#{file_name}.csv"
    end

    def self.headers
      [
        "Account Manager", "Developer", "Division", "Development", "Phase", "Plot",
        "First Name", "Surname", "Email", "Phone",
        "Access Level", "Months (Premium)", "Activated"
      ]
    end

    def self.plot_division(plot)
      plot.division_name if plot.division
    end

    def self.build_date(date)
      date.strftime("%d/%m/%Y")
    end
  end
end
