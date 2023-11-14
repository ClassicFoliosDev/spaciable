# frozen_string_literal: true

module ApplianceFixture
  module_function

  def description
    "Some text. Some more text"
  end

  def model_num
    "FF 456 T UK"
  end

  def clone_model_num
    "FF 789 T UK"
  end

  def updated_model_num
    "HH 654 F EU"
  end

  def full_name
    CreateFixture.appliance_manufacturer_name + " " + model_num
  end

  def updated_full_name
    updated_manufacturer + " " + updated_model_num
  end

  def description_display
    "Some text. Some more text"
  end

  def warranty_len
    "8 years"
  end

  def e_rating
    "A++"
  end

  def updated_category
    "Washing Machine"
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

  def second_appliance_category_name
    "Fridge Freezer"
  end

  def second_appliance_full_name
    second_manufacturer_name + " " + second_model_num
  end

  def second_manufacturer_name
    "Samsung"
  end

  def second_model_num
    "SF 456 TT"
  end

  def manufacturer_link
    "http://www.bosch-home.co.uk/register-your-appliance.html"
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

  def manual_url
    appliance_instance.manual.url
  end

  def guide_url
    appliance_instance.guide.url
  end

  def appliance_instance
    Appliance.find_by(model_num: CreateFixture.appliance_name)
  end
end
