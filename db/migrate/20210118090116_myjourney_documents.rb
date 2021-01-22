class MyjourneyDocuments < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :stage_sets do |t|
          t.integer :stage_set_type, default: 0
          t.boolean :clone, default: false
        end

        add_column :tasks, :title_indent, :integer, default: 1
        add_column :stages, :order, :integer, default: 1
        add_reference :stages, :stage_set, foreign_key: true
        add_reference :timelines, :stage_set, foreign_key: true

        uk = StageSet.create(stage_set_type: :uk)
        Stage.all.order(:id).each_with_index do |stage, index|
          stage.update_attributes(order: index+1, stage_set_id: uk.id)
        end

        scotland = StageSet.create(stage_set_type: :scotland)
        %w[Reservation Exchange Moving Living].each_with_index do |title, index|
          Stage.create(title: title, order: index+1, stage_set_id: scotland.id)
        end

        proforma = StageSet.create(stage_set_type: :proforma)
        %w[Chapter1 Chapter2 Chapter3 Chapter4].each_with_index do |title, index|
          Stage.create(title: title, order: index+1, stage_set_id: proforma.id)
        end

        Timeline.update_all(stage_set_id: uk.id)

        change_column_null :stages, :stage_set_id, false
        change_column_null :timelines, :stage_set_id, false
      }

      direction.down {
        remove_column :tasks, :title_indent
        remove_column :stages, :order
        remove_reference :stages, :stage_set
        remove_reference :timelines, :stage_set
        drop_table :stage_sets
      }
    end
  end
end
