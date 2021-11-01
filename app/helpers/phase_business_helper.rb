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
    parent.phases.count == parent.phases.where(package: :free).count
  end

  # Are there any free phases
  def any_phases_free?(parent)
    return parent.free? if parent.respond_to?(:free?)
    parent.phases.where(package: :free).count.positive?
  end

  # Are some phases free and some not
  def some_phases_free?(parent)
    !all_phases_free?(parent) && any_phases_free?(parent)
  end

  def free_phase_at_documents_limit?(parent)
    parent.is_a?(Phase) && parent.free? && parent.documents.count == 3
  end

  private

  def businesses_scope
    "activerecord.attributes.phase.businesses"
  end

  def packagess_scope
    "activerecord.attributes.phase.packages"
  end
end
