class Unlatch < ActiveRecord::Migration[5.0]
  def change
  	create_table :unlatch_developers do |t|
  	  t.references :developer, index: true
  	  t.string :api
  	  t.string :email
  	  t.string :password
  	  t.string :token
  	  t.datetime :expires
  	end

  	create_table :unlatch_programs do |t|
  	  t.references :developer
  	  t.references :development
  	end

  	create_table :unlatch_sections do |t|
  	  t.references :developer
  	  t.integer :category
  	end

  	create_table :unlatch_documents do |t|
  	  t.references :document
  	  t.references :program
  	  t.references :section
  	end

  	create_table :unlatch_lots do |t|
  	  t.references :plot
      t.references :program
  	end

    create_table :unlatch_logs do |t|
      t.references :linkable, polymorphic: true, index: false
      t.string :error
      t.timestamps null: false
    end
  end
end
