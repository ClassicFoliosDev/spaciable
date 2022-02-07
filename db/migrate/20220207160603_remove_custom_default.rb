class RemoveCustomDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:faqs, :faq_package, nil)
  end
end
