# frozen_string_literal: true
module AppliancesHelper
  def warranty_collection
    Appliance.warranty_lengths.map do |(warranty_name, _warranty_int)|
      [t(warranty_name, scope: warranty_scope), warranty_name]
    end
  end

  def rating_collection
    Appliance.e_ratings.map do |(rating_name, _rating_int)|
      [t(rating_name, scope: rating_scope), rating_name]
    end
  end

  private

  def warranty_scope
    "activerecord.attributes.appliance.warranty_length"
  end

  def rating_scope
    "activerecord.attributes.appliance.e_rating"
  end
end
