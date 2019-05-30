class AddChoices < ActiveRecord::Migration[5.0]
  def change

    create_table :choice_configurations do |t|
      t.string :name
      t.timestamps
      t.belongs_to :development
    end

    create_table :room_configurations do |t|
      t.string :name
      t.integer :icon_name
      t.timestamps
      t.belongs_to :choice_configuration
    end

    create_table :room_items do |t|
      t.string :name
      t.references :room_itemable, polymorphic: true, index: true
      t.timestamps
      t.belongs_to :room_configuration
    end

    create_table :choices do |t|
      t.references :choiceable, polymorphic: true, index: true
      t.timestamps
      t.belongs_to :room_item
    end

    create_table :room_choices do |t|
      t.belongs_to :plot
      t.belongs_to :room_item
      t.belongs_to :choice
    end

    add_column :plots, :choice_configuration_id, :integer
    add_column :plots, :choice_selection_status, :integer, default: 0, null: false

    add_column :developments, :choice_option, :integer, default: 0, null: false
    add_column :developments, :choices_email_contact, :string

  end
end
