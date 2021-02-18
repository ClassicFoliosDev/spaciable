class RemoveDashboard < ActiveRecord::Migration[5.0]
  def up
    Ahoy::Event.where(name: "Dashboard").destroy_all
  end
end
