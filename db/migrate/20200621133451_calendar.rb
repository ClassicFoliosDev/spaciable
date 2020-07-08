class Calendar < ActiveRecord::Migration[5.0]
  def change

    create_table :events do |t|
      t.references :eventable, polymorphic: true, index: true
      t.references :userable, polymorphic: true, index: true
      t.string   :title
      t.string   :location
      t.datetime :start
      t.datetime :end
      t.integer  :repeat
      t.datetime :repeat_until
      t.integer  :reminder
    end

    create_table   :event_resources do |t|
      t.references :event, index: true
      t.references :resourceable, polymorphic: true, index: true
      t.integer    :status
    end

  end
end
