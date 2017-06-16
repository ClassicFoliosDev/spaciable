# frozen_string_literal: true
class ManufacturerRelationshipsService
  def self.appliance_category_manufacturers(manufacturer_id)
    ApplianceCategory.all.each do |category|
      ApplianceCategoriesManufacturer.find_or_create_by!(manufacturer_id: manufacturer_id,
                                                         appliance_category_id: category.id)
    end
  end

  def self.remove_appliance_category_manufacturers(manufacturer)
    manufacturer.appliance_categories.each do |appliance_category|
      manufacturer.appliance_categories.delete(appliance_category)
    end
  end

  def self.finish_type_manufacturers(manufacturer_id, finish_category_id)
    finish_category_types = FinishCategoriesType.where(finish_category_id: finish_category_id)
    finish_category_types.each do |finish_category_type|
      FinishTypesManufacturer
        .find_or_create_by!(manufacturer_id: manufacturer_id,
                            finish_type_id: finish_category_type.finish_type_id)
    end
  end

  def self.remove_finish_type_manufacturers(manufacturer)
    manufacturer.finish_types.each do |finish_type|
      manufacturer.finish_types.delete(finish_type)
    end
  end

  def self.manufacturer_appliance_categories(appliance_category_id)
    manufacturers = Manufacturer.for_appliances
    manufacturers.each do |manufacturer|
      ApplianceCategoriesManufacturer
        .find_or_create_by!(manufacturer_id: manufacturer.id,
                            appliance_category_id: appliance_category_id)
    end
  end
end
