class HillDefaults < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        Rake::Task['hill:null_defaults'].invoke

        change_column_default :brands, :border_style, nil
        change_column_default :brands, :button_style, nil
        change_column_default :brands, :hero_height, nil
      }

      direction.down {
        change_column_default :brands, :border_style, Brand.border_styles[:line]
        change_column_default :brands, :button_style, Brand.button_styles[:round]
        change_column_default :brands, :hero_height, 195
      }
    end
  end
end
