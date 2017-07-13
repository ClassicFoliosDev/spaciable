#######################################################################################
# Only needed for testing the manufacturer migration task, do NOT run in staging/prod #
#######################################################################################

######################################
# Appliances and their Manufacturers #
######################################

manufacturers_and_links = {
    "ATAG" => "http://atagheating.co.uk/warranty-register/",
    "AEG" => "http://www.aeg.co.uk/mypages/register-a-product/",
    "Baumatic" => "https://olr.domesticandgeneral.com/app/pages/ApplicationPage.aspx?country=gb&lang=en&brand=BAUM~",
    "Beko" => nil,
    "Manufacturer for appliance and finish" => "http://example.com/register"
}.each_pair do |manufacturer_name, link|
  manufacturer = Manufacturer.find_or_initialize_by(name: manufacturer_name, link: link)

  if manufacturer.new_record?
    puts "Manufacturer: #{manufacturer_name} #{link}"
    manufacturer.save!
  end
end

categories =
[
  "Washing Machine",
  "Washer Dryer",
  "Tumble Dryer",
  "Fridge",
  "Freezer"
].each { |name| ApplianceCategory.find_or_create_by(name: name) }

######################################
# Finishes and their Manufacturers #
######################################

{
  "Wallcovering": {
    "Paint": [
      "Crown",
      "Dulux",
      "Farrow & Ball"
    ],
    "Wallpaper": [],
    "Ceramic Tiles": [
      "HR Johnson",
      "Porcelanosa",
      "Saloni"
    ],
    "Exposed Brickwork": [],
    "Wood Walls": []
  },
  "Woodwork": {
    "Paint": [
      "Crown",
      "Dulux",
      "Different manufacturer with same finish type"
    ],
    "Varnish": [
      "Crown" ,
      "Dulux",
      "Farrow & Ball",
      "Manufacturer for appliance and finish"
    ]
  }
}.each_pair do |category_name, types|
  finish_category = FinishCategory.find_or_initialize_by(name: category_name)

  if finish_category.new_record?
    puts "Finish Category: #{finish_category.name}" if Features.seed_output
    finish_category.save!
  end

  types.each_pair do |type_name, manufacturers|
    finish_type = FinishType.find_or_initialize_by(name: type_name)

    if finish_type.new_record?
      puts "Finish Type: #{finish_type.name}" if Features.seed_output
      finish_type.finish_categories = [finish_category]
      finish_type.save!(validate: false)
    end

    manufacturers.each do |manufacturer_name|
      manufacturer = Manufacturer.find_or_initialize_by(name: manufacturer_name)

      if manufacturer.new_record?
        puts "Manufacturer: #{manufacturer.name}" if Features.seed_output
        manufacturer.save!
      end

      finish_type.manufacturers << manufacturer unless finish_type.manufacturers.include?(manufacturer)
    end
  end
end
