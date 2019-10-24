# frozen_string_literal: true

module DevelopmentCsvFixture
  module_function

  def create_plots
    phase = Phase.find_by(name: PhasePlotFixture.phase_name)
    unit_type = UnitType.find_by(name: PhasePlotFixture.unit_type_name)
    (1..5).each do |p|
      FactoryGirl.create(:plot, phase: phase, unit_type: unit_type, number: p)
    end
  end
end
