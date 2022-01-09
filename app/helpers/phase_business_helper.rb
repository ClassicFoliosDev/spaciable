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

  # are all the phases free?
  def all_phases_free?(parent)
    return false unless parent.respond_to?(:phases)
    parent.phases.count == parent.phases.where(package: :free).count
  end

  # Are there any free phases
  def any_phases_free?(parent)
    any_phases?(parent, [:free])
  end

  def any_phases?(parent, packages)
    packages.each { |p| return parent.send("#{p}?") if parent.respond_to?("#{p}?") }
    parent.phases.where(package: packages).count.positive?
  end

  # Are some phases free and some not
  def some_phases_free?(parent)
    !all_phases_free?(parent) && any_phases_free?(parent)
  end

  def free_phase_at_feature_limit?(parent, features)
    return false if current_user.cf_admin?
    parent.is_a?(Phase) && parent.free? && features.count >= 3
  end

  private

  def businesses_scope
    "activerecord.attributes.phase.businesses"
  end

  def packagess_scope
    "activerecord.attributes.phase.packages"
  end
end
