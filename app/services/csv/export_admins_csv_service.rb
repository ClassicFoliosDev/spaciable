# frozen_string_literal: true

module Csv
  class ExportAdminsCsvService
    SEPERATOR = "'"

    class << self
      def call(users, params)
        path = init(params)

        ::CSV.open(path, "w+", headers: false) do |csv|
          csv << ["Email", "First Name", "Last Name", "Role",
                  "Developer", "Division", "Development"]
          users.map do |user|
            csv << [user["email"], user["first_name"], user["last_name"],
                    I18n.t(User.roles.key(user["role"])), user["company_name"],
                    user["division_name"], user["development_name"]]
          end
        end

        path
      end

      def init(params)
        filename = I18n.l(Time.zone.now, format: :file_time) + "_export_admins"
        %w[Developer Division Development].each do |klass|
          next if params["#{klass.downcase}_id"].blank?

          filename += "_" + klass.classify.constantize
                                 .find(params["#{klass.downcase}_id"]).identity
        end
        filename += "_" + params["role"] if params["role"].present?
        Rails.root.join("tmp/#{filename}.csv")
      end
    end
  end
end
