# frozen_string_literal: false

module PlotHelper
  def occupied_status(plot)
    "plot-occupancy #{Plot::OCCUPATION_STATUS.key(plot.occupancy?)} fa fa-user"
  end

  def p_label(item)
    t("plots.form." + item.to_s)
  end

  def show_lease_length(tenure)
    @material_info.tenure == 'leasehold'
  end

  def show_floor(property_type)
    %i[apartment duplex maisonette studio].include? @material_info.property_type.to_sym
  end

  def floor_plan
    Document.accessible_by(current_ability).where(guide: 'floor_plan')&.first
  end


end
