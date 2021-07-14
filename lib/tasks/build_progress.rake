# frozen_string_literal: true

namespace :build_progress do
  task initialise: :environment do
    init_build_progress
  end

  def init_build_progress
    # create the master build sequence
    sequence = BuildSequence.create(master: true)

    Plot.progresses.each do |t, v|
      text = nil
      case v
      when Plot.progresses[:soon]
        text = "Building soon"
      when Plot.progresses[:in_progress]
        text = "In Progress"
      when Plot.progresses[:roof_on]
        text = "Roof On"
      when Plot.progresses[:first_fix]
        text = "First Fix"
      when Plot.progresses[:second_fix]
        text = "Second Fix"
      when Plot.progresses[:kitchen]
        text = "Kitchen installed"
      when Plot.progresses[:sanitaryware]
        text = "Sanitaryware intalled"
      when Plot.progresses[:decoration]
        text = "Decoration completed"
      when Plot.progresses[:tiling]
        text = "Tiling Completed"
      when Plot.progresses[:flooring]
        text = "Flooring completed"
      when Plot.progresses[:driveway]
        text = "Patio/driveway completed"
      when Plot.progresses[:landscaping]
        text = "Landscaping Completed"
      when Plot.progresses[:exchange_ready]
        text = "Ready for exchange"
      when Plot.progresses[:complete_ready]
        text = "Ready to complete"
      when Plot.progresses[:completed]
        text = "Build completed"
      when Plot.progresses[:remove]
        text = "No progress status"
      end

      BuildStep.create(title: text,
                       description: text,
                       order: v + 1,
                       build_sequence: sequence)
    end

    Division.update_all(build_sequence_id: sequence.id)
    Developer.update_all(build_sequence_id: sequence.id)
  end

end
