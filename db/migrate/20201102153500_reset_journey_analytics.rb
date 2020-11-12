class ResetJourneyAnalytics < ActiveRecord::Migration[5.0]
  def up
    Ahoy::Event.where(name: "Your Journey").destroy_all
  end
end
