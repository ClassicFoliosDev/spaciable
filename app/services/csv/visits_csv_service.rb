# frozen_string_literal: true

module Csv
  class VisitsCsvService
    SEPERATOR = "'"

    class << self
      def call(visits_params)
        visits = VisitorFilter.new(visits_params)
        path = init(visits, build_filename(visits))

        ::CSV.open(path, "w+", headers: false) do |csv|
          summary(csv, visits)
          stats(csv, visits)
        end

        path
      end

      def init(visits, filename)
        formatted_from = I18n.l(visits.start_date, format: :digits)
        formatted_to = I18n.l(visits.end_date, format: :digits)
        Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
      end

      def build_filename(visits)
        now = I18n.l(Time.zone.now, format: :file_time)
        "#{now}_#{focus(visits)}.csv"
      end

      # rubocop:disable Metrics/AbcSize
      def summary(csv, visits)
        csv << ["Report Details:", nil, "Summary:"]
        csv << ["Starting Date", visits.start_date, "Plots", visits.plots.count]
        csv << ["Ending Date", visits.end_date, "Residents", visits.residents.count]
        csv << ["Focus", focus(visits), "Activated Residents in Period",
                visits.stats[:homeowner_sign_in]
                      .visit(Ahoy::Event::ACCEPT_INVITATION)&.unique || 0]
        csv << ["Business", visits.business || "All", "Unique Sign Ins",
                visits.stats[:homeowner_sign_in].unique || 0]
        csv << [nil, nil, "Sign Ins", visits.stats[:homeowner_sign_in]&.total || 0]
      end
      # rubocop:enable Metrics/AbcSize

      def stats(csv, visits)
        csv << [nil] << [nil]

        depth = visits.max_depth
        csv << ["Feature", (1..(depth - 1)).map { |v| "Category#{v}" },
                "Unique Resident Visits", "Total Resident Visits"].flatten
        Ahoy::Event.ahoy_event_names.each do |event, _|
          next if event == :homeowner_sign_in.to_s

          details(csv, visits.stats[event.to_sym], depth)
        end
      end

      def details(csv, stat, max_depth)
        csv << [Array.new(stat.depth - 1, nil), stat.title,
                Array.new(max_depth - stat.depth, nil),
                stat.unique, stat.total].flatten
        # recurse
        stat.visits.each { |s| details(csv, s, max_depth) }
      end

      private

      def focus(visits)
        "#{visits.developer_id ? Developer.find(visits.developer_id).company_name : 'All'}" \
        "_#{visits.division_id ? Division.find(visits.division_id).division_name : 'All'}" \
        "_#{visits.development_id ? Development.find(visits.development_id).name : 'All'}"
      end
    end
  end
end
