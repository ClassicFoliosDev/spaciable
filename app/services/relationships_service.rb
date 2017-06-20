# frozen_string_literal: true
class RelationshipsService
  def self.join_appliance_category_manufacturers(manufacturer_id)
    ApplianceCategory.all.each do |category|
      ApplianceCategoriesManufacturer.find_or_create_by!(manufacturer_id: manufacturer_id,
                                                         appliance_category_id: category.id)
    end
  end

  def self.remove_appliance_category_manufacturers(manufacturer)
    appliance_categories_manufacturers = ApplianceCategoriesManufacturer
                                         .where(manufacturer_id: manufacturer.id)

    appliance_categories_manufacturers.each do |appliance_categories_manufacturer|
      manufacturer.appliance_categories
                  .delete(appliance_categories_manufacturer.appliance_category)
    end
  end

  def self.join_finish_type_manufacturers(manufacturer, finish_category_id)
    # Tidy up old finish manufacturer assignments
    remove_finish_type_manufacturers(manufacturer)

    finish_category_types = FinishCategoriesType.where(finish_category_id: finish_category_id)
    finish_category_types.each do |finish_category_type|
      FinishTypesManufacturer
        .find_or_create_by!(manufacturer_id: manufacturer.id,
                            finish_type_id: finish_category_type.finish_type_id)
    end
  end

  def self.remove_finish_type_manufacturers(manufacturer)
    manufacturer.finish_types.each do |finish_type|
      manufacturer.finish_types.delete(finish_type)
    end
  end

  def self.join_manufacturer_appliance_categories(appliance_category_id)
    manufacturers = Manufacturer.for_appliances
    manufacturers.each do |manufacturer|
      ApplianceCategoriesManufacturer
        .find_or_create_by!(manufacturer_id: manufacturer.id,
                            appliance_category_id: appliance_category_id)
    end
  end

  def self.join_finish_category_types(finish_type, finish_category_id)
    return if finish_category_id == finish_type&.finish_categories&.first&.id

    finish_type.finish_categories.each do |finish_category|
      finish_type.finish_categories.delete(finish_category)
    end

    FinishCategoriesType.create!(finish_type_id: finish_type.id,
                                 finish_category_id: finish_category_id)
  end
end
