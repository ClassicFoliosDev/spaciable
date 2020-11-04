class CustomUrl < ActiveRecord::Migration[5.0]
  def change
   reversible do |direction|

      direction.up {

        add_column :developers, :custom_url, :string
        Developer.all.each { |d| d.update!(custom_url: d.company_name.parameterize) }
      }

      direction.down {
        remove_column :developers, :custom_url
      }
    end
  end
end
