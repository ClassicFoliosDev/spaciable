# frozen_string_literal: true

namespace :hill do
  task null_defaults: :environment do
    Brand.where(hero_height: 195).update_all(hero_height: nil)
    Brand.where(border_style: :line).update_all(border_style: nil)
    Brand.where(button_style: :round).update_all(button_style: nil)
  end
end
