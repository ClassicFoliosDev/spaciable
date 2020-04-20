class RationaliseFinishTypes < ActiveRecord::Migration[5.0]

  # This is hard to explain.  The migration should not use the models as they can change over time and
  # could be a problem when building databases from scratch.  The idea is to define 'local' migration only
  # versions that simply define the relationships between the tables you need to use for this migration
  #
  # This means all the migration code is using these local copies rather than the ones in the models folder
  class FinishType < ActiveRecord::Base
    has_many :finish_categories_type, :class_name => 'RationaliseFinishTypes::FinishCategoriesType', dependent: :destroy
    has_many :finish_types_manufacturer, :class_name => 'RationaliseFinishTypes::FinishTypesManufacturer', dependent: :destroy
  end

  class FinishCategoriesType < ActiveRecord::Base
  end

  class FinishTypesManufacturer < ActiveRecord::Base
  end

  class Finish < ActiveRecord::Base
  end

  def up
    # Get an array of all finish types in order.  Use an array as the process will
    # delete finish types as it goes through the rationalisation process
    FinishType.where(developer_id: nil).order(:name).to_a.each do |finish_type|
      # Define a regular expression to find type names that are the same except for
      # trailing spaces.  the gsubs are to escape brackets that appear in the
      # type name ie 'Door (Front)'.  The [ ]* means zero or more spaces to the
      # end of the line
      regex = "^#{finish_type.name.gsub(/(\()/, '\\(').gsub(/\)/, '\\)')}[ ]*$"
      # How many versions of this finish type are there
      versions = FinishType.where('name ~* :match AND developer_id IS null', :match => regex).to_a

      # If there are multiple versions - then they must be rationaised.  The current finish_type will be
      # the master as it will be the one with no trailing spaces - as it appears first in the ordered
      # list. We just have to deal with the other versions
      versions.delete_if { |v| v.id == finish_type.id }
      versions.each do |version|
        # Which finish categories are associated with the finish_type and version
        master_cats = finish_type.finish_categories_type.pluck(:finish_category_id)
        version_cats = version.finish_categories_type.pluck(:finish_category_id)
        # What new categories are there to add
        (version_cats - master_cats).each do |category|
          # add the new category to the master finish_type record
          FinishCategoriesType.new(finish_type_id: finish_type.id,
                                   finish_category_id: category).save
        end

        # Which finish manufacturers are associated with the finish_type and version
        master_mans = finish_type.finish_types_manufacturer.pluck(:finish_manufacturer_id)
        version_mans = version.finish_types_manufacturer.pluck(:finish_manufacturer_id)
        (version_mans - master_mans).each do |manufacturer|
          # add the new manufacturer to the master finish_type record
          FinishTypesManufacturer.new(finish_type_id: finish_type.id,
                                      finish_manufacturer_id: manufacturer).save
        end

        # update all finishes to use the master
        Finish.where(finish_type_id: version).update_all(finish_type_id: finish_type.id)

        #delete version - and dependent records
        FinishType.find(version.id).delete
      end

    end
  end

  def down
  end

end
