class AddInvitedByToPlotResidency < ActiveRecord::Migration[5.0]
  def up
    change_table :plot_residencies do |t|
      t.references :invited_by, polymorphic: true
    end
  end

  def down
    change_table :plot_residencies do |t|
      t.remove_references :invited_by, polymorphic: true
    end
  end
end
