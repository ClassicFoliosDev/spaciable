namespace :manufacturers do
  desc "migrate manufacturers to appliance and finish manufacturers"
  task migrate: :environment do

    log_file = "log/manufacturers_migration.log"
    logger = Logger.new log_file

    logger.info(">>>>>>>> New migration <<<<<<<<")

    migrate_manufacturers(logger)

    logger.info(">>>>>>> Tidy up duplicate relationships <<<<<<<<<")

    remove_duplicate_finish_categories_types

    logger.info(">>>>>>>> <<<<<<<<")

  end

  def migrate_manufacturers(logger)
    ActiveRecord::Base.transaction do
      Manufacturer.all.each do | manufacturer|

        finish_types_with_references = FinishTypesManufacturer.where(manufacturer_id: manufacturer.id)
        if finish_types_with_references.length.positive?
          migrate_finish_manufacturer(manufacturer, logger)
        end

        appliances_with_references = Appliance.where(manufacturer_id: manufacturer.id)
        if appliances_with_references.length.positive?
          migrate_appliance_manufacturer(manufacturer, logger, appliances_with_references)
        end

        reference_count = finish_types_with_references.length + appliances_with_references.length
        if reference_count == 0
          # Finish type is mandatory for finish manufacturer, so if there are no finish types
          # it must be an appliance manufacturer
          create_appliance_manufacturer(manufacturer, logger)
        end
      end
    end
  end

  def create_appliance_manufacturer(manufacturer, logger)
    appliance_manufacturer = ApplianceManufacturer.find_or_create_by(
        name: manufacturer.name,
        link: manufacturer.link)

    logger.info("Created or found appliance manufacturer #{appliance_manufacturer.id}: #{appliance_manufacturer.name}")

    appliance_manufacturer
  end

  def create_finish_manufacturer(manufacturer, logger)
    finish_types = manufacturer.finish_types

    finish_manufacturer = FinishManufacturer.find_by(name: manufacturer.name)
    if finish_manufacturer.nil?
      finish_manufacturer = FinishManufacturer.new(name: manufacturer.name)
      finish_manufacturer.finish_types << finish_types
      finish_manufacturer.save!
    end

    logger.info("Created or found finish manufacturer #{finish_manufacturer.id}: #{finish_manufacturer.name} with #{finish_types.length} finish types")

    finish_manufacturer
  end

  def remove_manufacturer(manufacturer, logger)
    manufacturer.destroy

    logger.info("------ Manufacturer #{manufacturer.name} destroyed ------")
  end

  def migrate_finish_manufacturer(manufacturer, logger)

    finish_manufacturer = create_finish_manufacturer(manufacturer, logger)
    finishes = Finish.where(manufacturer_id: manufacturer.id)

    finishes.each do | finish |
      finish.update_attribute(:finish_manufacturer_id, finish_manufacturer.id)
      logger.info("  connected to finish #{finish.to_s}")
    end

    logger.info("Connections complete for #{finish_manufacturer.to_s}")
  end

  def migrate_appliance_manufacturer(manufacturer, logger, appliances_with_references)
    appliance_manufacturer = create_appliance_manufacturer(manufacturer, logger)

    appliances_with_references.each do | appliance |
      appliance.update_attribute(:appliance_manufacturer_id, appliance_manufacturer.id)
      logger.info("  connected to appliance #{appliance.to_s}")
    end

    logger.info("Connections complete for #{appliance_manufacturer.to_s}")
  end

  def remove_duplicate_finish_categories_types
    finish_categories_types = FinishCategoriesType.all
    finish_categories_types_to_keep = []

    finish_categories_types.each do | finish_categories_type |
      finish_categories_type_combined_id = [finish_categories_type.finish_category_id,
                                            finish_categories_type.finish_type_id]
       unless finish_categories_types_to_keep.include?(finish_categories_type_combined_id)
         finish_categories_types_to_keep << finish_categories_type_combined_id
      end
    end

    ActiveRecord::Base.connection.execute("DELETE from finish_categories_types")

    finish_categories_types_to_keep.each do | finish_categories_type_ids |
      finish_category_id = finish_categories_type_ids[0]
      finish_type_id = finish_categories_type_ids[1]

      FinishCategoriesType.create(finish_category_id: finish_category_id, finish_type_id: finish_type_id)
    end
  end
end
