# frozen_string_literal: true

namespace :dynamic_spotlights do
  task migrate: :environment do
    migrate
  end

  def migrate
    CustomTile.all.each do |tile|
      spotlight = Spotlight.create(development_id: tile.development_id,
                                   cf: tile.cf,
                                   editable: tile.editable,
                                   appears: tile.appears)
      tile.update_attribute(:spotlight, spotlight)
    end
  end
end
