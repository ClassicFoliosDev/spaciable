# frozen_string_literal: true

module DevelopmentBusinessHelper
  def development_businesses_collection
    Development.businesses.map do |(business_name, _business_int)|
      [t(business_name, scope: businesses_scope), business_name]
    end
  end

  private

  def businesses_scope
    "activerecord.attributes.development.businesses"
  end
end
