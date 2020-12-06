class MyJourney < ActiveRecord::Migration[5.0]
  def change
     # "Your Journey" -> "My Journey"
    Ahoy::Event.where(name: "Your Journey").update_all(name: "My Journey")
  end
end
