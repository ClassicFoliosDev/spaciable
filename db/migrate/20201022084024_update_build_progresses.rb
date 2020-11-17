class UpdateBuildProgresses < ActiveRecord::Migration[5.0]
  def change
    load Rails.root.join("db/seeds", "build_progresses.rb")
  end
end
