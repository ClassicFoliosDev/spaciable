class MyjourneyDocuments < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :stage_sets do |t|
          t.integer :stage_set_type, default: 0
          t.boolean :clone, default: false
        end

        add_column :tasks, :title_class, :integer, default: 0
        add_column :stages, :order, :integer, default: 1
        add_reference :stages, :stage_set, foreign_key: true
        add_reference :timelines, :stage_set, foreign_key: true
        add_column :timelines, :description, :string, default: "Track your progress towards your move and pick up plenty of tips along the way."
        add_reference :custom_tiles, :tileable, polymorphic: true, index: true

        journey = StageSet.create(stage_set_type: :journey)
        Stage.all.order(:id).each_with_index do |stage, index|
          stage.update_attributes(order: index+1, stage_set_id: journey.id)
        end

        proforma = StageSet.create(stage_set_type: :proforma)
        %w[Reservation Exchange Moving Living].each_with_index do |title, index|
          Stage.create(title: title, order: index+1, stage_set_id: proforma.id)
        end

        Timeline.update_all(stage_set_id: journey.id)

        change_column_null :stages, :stage_set_id, false
        change_column_null :timelines, :stage_set_id, false
      }

      direction.down {
        remove_column :tasks, :title_class
        remove_column :stages, :order
        remove_reference :stages, :stage_set
        remove_reference :timelines, :stage_set
        remove_column :timelines, :description
        remove_reference :custom_tiles, :tileable, polymorphic: true
        drop_table :stage_sets
      }
    end
  end
end
