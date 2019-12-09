# frozen_string_literal: false

require "csv"
module Csv
  class SummaryCsvService
    def self.init(report, filename)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      formatted_from = I18n.l(@from.to_date, format: :digits)
      formatted_to = I18n.l(@to.to_date, format: :digits)

      Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
    end

    def self.active_plots_count(parent)
      all_plots = all_plots_count(parent)
      active_plots = 0
      all_plots.each do |plot|
        active_plots += 1 unless plot.expired?
      end

      active_plots
    end

    def self.expired_plots_count(parent)
      all_plots = all_plots_count(parent)
      expired_plots = 0
      all_plots.each do |plot|
        expired_plots += 1 if plot.expired?
      end

      expired_plots
    end

    def self.all_plots_count(parent)
      parent.plots.where('completion_release_date IS NOT :search OR
                         reservation_release_date IS NOT :search', search: nil)
    end

    # plots with a reservation release date and no completion release date
    def self.reservation_plots_count(parent)
      parent.plots.where('reservation_release_date IS NOT :search AND
                          completion_release_date IS :search', search: nil).count
    end

    def self.completion_plots_count(parent)
      parent.plots.where.not(completion_release_date: nil).count
    end

    def self.activated_resident_count(parent)
      parent.residents.where.not(invitation_accepted_at: nil).count
    end

    def self.admin_count(parent)
      parent.admin_list.size
    end

    def self.activated_admin_count(parent)
      all_admins = parent.admin_list
      activated_count = 0
      all_admins.each do |admin|
        activated_count += 1 unless admin.invitation_accepted_at.nil?
      end

      activated_count
    end

    # count notifications sent by all admins under the developer/division
    def self.notification_count(parent)
      all_admins = parent.admin_list
      sent_notifications = 0
      all_admins.each do |admin|
        sent_notifications += Notification.where(sender_id: admin.id).count
      end

      sent_notifications
    end

    def self.developer_emails_count(parent)
      parent.residents.where(developer_email_updates: 1).count
    end

    def self.spaciable_emails_count(parent)
      parent.residents.where(cf_email_updates: 1).count
    end

    def self.maintenance_count(parent)
      parent.developments.where.not(maintenance_link: "").count
    end

    def self.snagging_enabled_count(parent)
      parent.developments.where(enable_snagging: true).count
    end

    def self.total_snags_count(parent)
      total_snags = 0
      parent.plots.each do |plot|
        total_snags += plot.all_snags_count
      end

      total_snags
    end

    def self.resolved_snags_count(parent)
      resolved_snags = 0
      parent.plots.each do |plot|
        resolved_snags += plot.resolved_snags_count
      end

      resolved_snags
    end

    def self.phases_business_count(parent, business)
      parent.phases.where(business: business).count
    end

    def self.build_date(record, column)
      return "" if record.send(column).nil?
      record.send(column).strftime("%d/%m/%Y")
    end

    def self.yes_or_no(record, column)
      return "No" if record.send(column).nil?
      return(record.send(column).positive? ? "Yes" : "No") if record.send(column).is_a? Integer
      "No"
    end

    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)

      "#{now}_#{file_name}.csv"
    end
  end
end
# rubocop:enable Metrics/ClassLength
