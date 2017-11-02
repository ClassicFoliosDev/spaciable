# frozen_string_literal: true

module MigrateManufacturersFixture
  module_function

  def setup
    create_appliances
    create_finishes
  end

  def create_appliances
    FactoryGirl.create(:appliance,
                       manufacturer_id: appliance_manufacturer.id,
                       appliance_category_id: appliance_category.id,
                       model_num: model_num)

    FactoryGirl.create(:appliance,
                       manufacturer_id: appliance_and_finish_manufacturer.id,
                       appliance_category_id: appliance_category.id,
                       model_num: second_model_num)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def create_finishes
    FactoryGirl.create(:finish,
                       manufacturer_id: finish_manufacturer.id,
                       finish_category_id: finish_category.id,
                       finish_type_id: finish_type.id,
                       name: finish_name_one)

    FactoryGirl.create(:finish,
                       manufacturer_id: finish_multiple_category_manufacturer.id,
                       finish_category_id: second_finish_category.id,
                       finish_type_id: finish_type.id,
                       name: finish_name_two)

    FactoryGirl.create(:finish,
                       manufacturer_id: appliance_and_finish_manufacturer.id,
                       finish_category_id: second_finish_category.id,
                       finish_type_id: second_finish_type.id,
                       name: finish_name_three)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  def finish_name_one
    "Finish farrow & ball paint wallcovering"
  end

  def finish_name_two
    "Finish different manufacturer with same finish type paint woodwork"
  end

  def finish_name_three
    "Finish manufacturer for appliance and finish varnish woodwork"
  end

  def appliance_manufacturer_name
    "ATAG"
  end

  def appliance_and_finish_manufacturer_name
    "Manufacturer for appliance and finish"
  end

  def appliance_manufacturer
    Manufacturer.find_by(name: appliance_manufacturer_name)
  end

  def appliance_and_finish_manufacturer
    Manufacturer.find_by(name: appliance_and_finish_manufacturer_name)
  end

  def appliance_category_name
    "Washer Dryer"
  end

  def appliance_category
    ApplianceCategory.find_by(name: appliance_category_name)
  end

  def finish_manufacturer_name
    "Farrow & Ball"
  end

  def finish_manufacturer
    Manufacturer.find_by(name: finish_manufacturer_name)
  end

  def finish_multiple_category_manufacturer_name
    "Different manufacturer with same finish type"
  end

  def finish_multiple_category_manufacturer
    Manufacturer.find_by(name: finish_multiple_category_manufacturer_name)
  end

  def finish_type
    FinishType.find_by(name: "Paint")
  end

  def second_finish_type
    FinishType.find_by(name: "Varnish")
  end

  def finish_category
    FinishCategory.find_by(name: "Wallcovering")
  end

  def second_finish_category
    FinishCategory.find_by(name: "Woodwork")
  end

  def model_num
    "YTC 7654"
  end

  def second_model_num
    "FA 4567"
  end
end
