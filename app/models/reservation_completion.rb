# frozen_string_literal: true

class ReservationCompletion
  class << self
    # Calculate and send the invoices
    def send_reminders
      Lock.run :res_comp_reminders do
        no_comp_since_last_res
        no_comp_since_last_comp
      end
    end

    # rubocop:disable Metrics/LineLength
    def no_comp_since_last_res
      dev_plots = resolve_developments(ActiveRecord::Base.connection.execute(no_comp_since_last_res_q).values)
      dev_plots.each do |dev, plots|
        NoCompMailer.no_comp_since_last_res(Development.find(dev), Plot.where(id: plots)).deliver_now
      end
    end
    # rubocop:enable Metrics/LineLength

    # Find developments where the last res was 8 weeks ago and no completions
    # have been made since.  Then find all the plots on those developments
    # that haven't been called off
    def no_comp_since_last_res_q
      <<-SQL
        SELECT d.id, p.id FROM developments d INNER JOIN plots p
          ON d.id = p.development_id
          WHERE
            p.completion_release_date is null AND
            p.reservation_release_date is not null AND d.id IN
            (SELECT d.id FROM developments d INNER JOIN plots p
               ON d.id = p.development_id
               INNER JOIN (SELECT development_id,
                                  MAX(reservation_release_date) max_reservation_release_date,
                                  MAX(completion_release_date) max_completion_release_date
                           FROM plots p2 GROUP BY development_id) SubQ
               ON SubQ.development_id = d.id AND
                  SubQ.max_reservation_release_date = (SELECT CURRENT_DATE - INTERVAL '8 week') AND
                  (SubQ.max_completion_release_date < SubQ.max_reservation_release_date OR
                   SubQ.max_completion_release_date is null) group by d.id)
        GROUP BY d.id, p.id
      SQL
    end

    # rubocop:disable Metrics/LineLength
    def no_comp_since_last_comp
      dev_plots = resolve_developments(ActiveRecord::Base.connection.execute(no_comp_since_last_comp_q).values)
      dev_plots.each do |dev, plots|
        NoCompMailer.no_comp_since_last_comp(Development.find(dev), Plot.where(id: plots)).deliver_now
      end
    end
    # rubocop:enable Metrics/LineLength

    # Find the developments where the last completion was made 4 weeks ago then identify all
    # the plots not called off
    def no_comp_since_last_comp_q
      <<-SQL
        SELECT d.id, p.id FROM developments d INNER JOIN plots p
          ON d.id = p.development_id
          WHERE p.completion_release_date is null AND
                p.reservation_release_date is not null AND
            d.id IN (SELECT d.id FROM developments d INNER JOIN plots p
                       ON d.id = p.development_id
                       INNER JOIN (SELECT development_id,
                                          MAX(completion_release_date) max_completion_release_date
                                   FROM plots p2 GROUP BY development_id) SubQ
                         ON SubQ.development_id = d.id AND
                            SubQ.max_completion_release_date = (SELECT CURRENT_DATE - INTERVAL '4 week') group by d.id)
        GROUP BY d.id, p.id
      SQL
    end

    private

    def resolve_developments(dev_plot_pairs)
      dev_plots = {}
      dev_plot_pairs.each { |d, p| dev_plots[d].nil? ? dev_plots[d] = [p] : dev_plots[d].push(p) }
      dev_plots
    end
  end
end
