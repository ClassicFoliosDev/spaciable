# frozen_string_literal: true

class AutoComplete
  def self.now
    AutoCompletePlotsJob.perform_now
  end
end
