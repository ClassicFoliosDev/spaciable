# frozen_string_literal: true

namespace :build_progress do
  task initialise: :environment do
    init_build_progress
  end

  def init_build_progress

    Global.create(name: "CFAdmin") if Global.first.nil?

    # create the master build sequence
    sequence = BuildSequence.create(build_sequenceable: Global.first)

    # migrate all 'no progress status' plots (value 15) to 'soon' (0)
    Plot.where(progress: 15).update_all(progress: 0)

    Plot.progresses.each do |t, v|
      BuildStep.create(title: I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                       description: "Your Build Progress has been updated to:\r\n\r\n" +
                                    I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                       order: v + 1,
                       build_sequence: sequence)
    end

    Global.build_sequence.build_steps.each do |step|
      plots = Plot.where(progress: step.order - 1).update_all(build_step_id: step.id)
    end

  end

end
