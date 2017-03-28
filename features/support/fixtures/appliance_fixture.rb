# frozen_string_literal: true
# rubocop:disable ModuleLength
module ApplianceFixture
  module_function

  def description
    "Some text\nSome more text"
  end

  def model_num
    "FF 456 T UK"
  end

  def updated_model_num
    "HH 654 F EU"
  end

  def full_name
    category + " " + manufacturer + " " + model_num
  end

  def updated_full_name
    updated_category + " " + updated_manufacturer + " " + updated_model_num
  end

  def description_display
    "Some text\r\nSome more text"
  end

  def warranty_len
    "8 years"
  end

  def e_rating
    "A++"
  end

  def category
    "Freezer"
  end

  def updated_category
    "Washing Machine"
  end

  def manufacturer
    "Bosch"
  end

  def updated_manufacturer
    "AEG"
  end

  def updated_attrs
    {
      category: updated_category,
      manufaturer: updated_manufacturer,
      warranty_len: warranty_len,
      e_rating: e_rating,
      description: description,
      model_num: updated_model_num
    }
  end

  def second_appliance_name
    "Samsung fridge freezer"
  end

  def second_appliance_category_name
    "Fridge freezer"
  end

  def second_manufacturer_name
    "Samsung"
  end

  def second_manufacturer_link
    "http://www.samsung.com/us/support/register/product"
  end

  def second_energy_rating
    "a3"
  end

  def update_appliance_manual
    filename = FileFixture.manual_name
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      CreateFixture.appliance.update_attribute(:manual, file)
    end
  end

  def update_appliance_guide
    filename = FileFixture.document_name
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      CreateFixture.appliance.update_attribute(:guide, file)
    end
  end

  def update_appliance_primary_image
    filename = FileFixture.appliance_primary_picture_name
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      CreateFixture.appliance.update_attribute(:primary_image, file)
    end
  end

  def update_appliance_secondary_image
    filename = FileFixture.appliance_secondary_picture_name
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      CreateFixture.appliance.update_attribute(:secondary_image, file)
    end
  end

  def create_appliance_with_guide
    appliance2 = create_second_appliance

    FactoryGirl.create(:appliance_room, room: CreateFixture.room, appliance: appliance2)

    filename = FileFixture.document_name
    file_path = Rails.root.join("features", "support", "files", filename)
    File.open(file_path) do |file|
      appliance2.update_attribute(:guide, file)
    end
  end

  def create_second_appliance
    second_appliance_category = ApplianceCategory.find_or_create_by(name: second_appliance_category_name)
    second_manufacturer = Manufacturer.find_or_create_by(name: second_manufacturer_name, link: second_manufacturer_link)

    FactoryGirl.create(
      :appliance,
      name: second_appliance_name,
      appliance_category: second_appliance_category,
      manufacturer: second_manufacturer,
      e_rating: second_energy_rating
    )
  end
end
# rubocop:enable ModuleLength
