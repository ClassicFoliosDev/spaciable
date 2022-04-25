# frozen_string_literal: true

namespace :ratings do
  task migrate: :environment do
    migrate_ratings
  end

  def migrate_ratings
    Appliance.where(e_rating: [7,8,9]).each do |appliance|
      appliance.update_columns(main_uk_e_rating: (appliance.e_rating_before_type_cast.to_i-3),
                               e_rating: nil)
    end
  end
end
