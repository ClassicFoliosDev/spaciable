# frozen_string_literal: true

namespace :ratings do
  task migrate: :environment do
    migrate_ratings
  end

  def migrate_ratings
    Appliance.where(e_rating: ['e','f','g']).each do |appliance|
      appliance.update_columns(main_uk_e_rating: appliance.e_rating,
                               e_rating: nil)
    end
  end
end
