class AddShowVideoToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :intro_video_enabled, :boolean, default: true
  end
end
