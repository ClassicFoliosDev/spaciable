# frozen_string_literal: true

module PhaseBusinessHelper
  def phase_businesses_collection
    Phase.businesses.map do |(business_name, _business_int)|
      [t(business_name, scope: businesses_scope), business_name]
    end
  end

  private

  def businesses_scope
    "activerecord.attributes.phase.businesses"
  end
end
