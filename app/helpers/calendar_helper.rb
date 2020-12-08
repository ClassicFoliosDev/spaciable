# frozen_string_literal: true

module CalendarHelper
  def event_resource(source)
    {
      tag: source.is_a?(Plot) ? "Select Attendees" : "Select Plots",
      data: source.is_a?(Plot) ? source.residents : source.plots,
      type: source.is_a?(Plot) ? Resident : Plot
    }
  end
end
