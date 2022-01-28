class Fixflow < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :ff_plots, :integer, default: 0
  end
end
