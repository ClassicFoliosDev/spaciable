# frozen_string_literal: true

module PhaseBusinessHelper
  def phase_businesses_collection
    Phase.businesses.map do |(business_name, _business_int)|
      [t(business_name, scope: businesses_scope), business_name]
    end
  end

  def phase_packages_collection
    Phase.packages.map do |(package_name, _package_int)|
      [t(package_name, scope: packagess_scope), package_name]
    end
  end

  def disabled_phase_packages(phase)
    return %i[professional legacy] if phase.res_comp? && phase.free?
    []
  end

  def free_phases?(parent)
    parent.phases.where(package: :free).count.positive?
  end

  private

  def businesses_scope
    "activerecord.attributes.phase.businesses"
  end

  def packagess_scope
    "activerecord.attributes.phase.packages"
  end
end
