# frozen_string_literal: false

module PlotHelper
  def occupied_status(plot)
    "plot-occupancy #{Plot::OCCUPATION_STATUS.key(plot.occupancy?)} fa fa-user"
  end

  def p_label(item)
    t("plots.form." + item.to_s)
  end

  def show_lease_length(tenure, lease_length)
    tenure == "leasehold" && lease_length&.positive?
  end

  def show_floor(property_type)
    %i[apartment duplex maisonette studio].include? property_type.to_sym
  end

  def floor_plan
    Document.accessible_by(current_ability).where(guide: "floor_plan")&.first
  end
end
