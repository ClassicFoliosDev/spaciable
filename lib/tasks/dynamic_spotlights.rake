# frozen_string_literal: true

namespace :dynamic_spotlights do
  task migrate: :environment do
    migrate
  end

  def migrate
    CustomTile.all.each do |tile|
      spotlight = Spotlight.create(development: tile.development,
                                   cf: tile.cf,
                                   editable: tile.editable)
      tile.update_attribute(:spotlight, spotlight)
    end
  end
end
