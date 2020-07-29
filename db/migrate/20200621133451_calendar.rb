class Calendar < ActiveRecord::Migration[5.0]
  def change

    create_table :events do |t|
      t.references :eventable, polymorphic: true, index: true
      t.references :userable, polymorphic: true, index: true
      t.references :master, index: true, foreign_key: { to_table: :events }
      t.string   :title
      t.string   :location
      t.datetime :start
      t.datetime :end
      t.integer  :repeat
      t.datetime :repeat_until
      t.integer  :reminder
      t.integer  :reminder_id
    end

    create_table   :event_resources do |t|
      t.references :event, index: true
      t.references :resourceable, polymorphic: true, index: true
      t.integer    :status
      t.datetime   :status_updated_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime   :proposed_start
      t.datetime   :proposed_end
    end

  end
end
