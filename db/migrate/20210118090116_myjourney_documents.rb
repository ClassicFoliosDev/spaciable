class MyjourneyDocuments < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :stage_sets do |t|
          t.integer :stage_set_type, default: 0
        end

        uk = StageSet.create(stage_set_type: :uk)
        StageSet.create(stage_set_type: :scotland)
        StageSet.create(stage_set_type: :proforma)

        add_column :tasks, :title_indent, :integer, default: 1
        #add_column :timeline_stages, :title, :string

        add_column :stages, :order, :integer, default: 1
        add_reference :stages, :stage_set, foreign_key: true
        add_reference :timelines, :stage_set, foreign_key: true

        Stage.update_all(stage_set_id: uk.id)
        Timeline.update_all(stage_set_id: uk.id)

        change_column_null :stages, :stage_set_id, false
        change_column_null :timelines, :stage_set_id, false

        Stage.all.order(:id).each_with_index do |stage, index|
          stage.update_attribute(:order, index+1)
        end

        #TimelineStage.all.each { |ts| ts.update_attribute(:title, Stage.find(ts.stage_id).title) }
        #remove_reference :timeline_stages, :stage
      }

      direction.down {
        Stage.joins(:timeline_template)
             .where(timeline_templates: { template_type: [TimelineTemplate.template_types[:scotland],
                                                          TimelineTemplate.template_types[:proforma]]})
             .destroy_all

        remove_column :tasks, :title_indent
        remove_reference :stages, :timeline_template
        remove_reference :timelines, :timeline_template
        drop_table :timeline_templates

        add_reference :timeline_stages, :stage
        TimelineStage.all.each { |tt| tt.update_attribute(:stage_id, Stage.find_by(title: tt.title).id) }
        remove_column :timeline_stages, :title
      }
    end
  end
end
