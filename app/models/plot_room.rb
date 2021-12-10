# frozen_string_literal: true

# PlotRoom supports specialist security for plot rooms.  A seperate
# class is used in order to allow room specific access for rooms
# associated with plots.  The associations are complicated and can be
# through unit types or direct to plots.  This class allows the code
# to identify particular situations where context sensitive access
# needs to be applied.  The class looks to simply wrap a Plot, but
# security is configured using classes and the Plot class has an array
# of other security settings that are mutuly exclusive with the needs
# of plot rooms
class PlotRoom
  attr_accessor :plot

  delegate :development_id, to: :plot
  delegate :completion_release_date, to: :plot
  delegate :phase_id, to: :plot

  def initialize(plot)
    @plot = plot
  end
end
