class PackageInvoicingExtention < ActiveRecord::Migration[5.2]
  def change
    add_column :developments, :invoice_indefinately, :boolean, default: false
  end
end
