class CalendarBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :calendar_fill_hover, :string
  end
end
