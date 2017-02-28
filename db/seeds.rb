# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its
# default values.
# The data can then be loaded with the rails db:seed command (or created alongside the
# database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if User.cf_admin.none?
  admin_email = "admin@alliants.com"
  admin_password = "12345678"

  User.create!(
    role: :cf_admin,
    email: admin_email,
    password: admin_password
  )

  STDOUT.puts <<-INFO

  #{'*' * 100}
  Default Admin user has been added:
    email: admin@alliants.com
    password: 12345678
  #{'*' * 100}

  INFO
end

if Rails.env.development?
  resident_email = "homeowner@alliants.com"

  if Resident.none?
    resident_password = "12345678"

    FactoryGirl.create(:resident, email: resident_email, password: resident_password)

    STDOUT.puts <<-INFO
    #{'*' * 100}
      Resident has been added:
        email: #{resident_email}
        password: #{resident_password}
    #{'*' * 100}
    INFO
  end

  resident = Resident.find_by(email: resident_email)

  if resident.plot.nil?
    FactoryGirl.create(:plot, :with_resident, resident: resident)
  end

  resident.reload
  plot = resident.plot

  if plot.developer.contacts.empty?
    Contact.categories.keys.each do |category|
      FactoryGirl.create_list(:contact, 10, category: category, contactable: plot.developer)
      FactoryGirl.create_list(:contact, 10, category: category, contactable: plot.development)
    end
  end

  if resident.plot.developer.faqs.empty?
    Faq.categories.keys.each do |category|
      FactoryGirl.create_list(:faq, 10, category: category, faqable: plot.developer)
      FactoryGirl.create_list(:faq, 10, category: category, faqable: plot.development)
    end
  end
end


if HomeownerLoginContent.none?
  content = HomeownerLoginContent.new
  content.title_left = I18n.t('residents.sessions.new.title.left')
  content.title_right = I18n.t('residents.sessions.new.title.right')
  content.blurb_para_1 = I18n.t('residents.sessions.new.intro_para_1')
  content.blurb_para_2 = I18n.t('residents.sessions.new.intro_para_2')
  content.save!
end

####################################################
# Finish Categories, Types and their Manufacturers #
####################################################
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
      "Farrow & Ball"
    ],
    "Varnish": [
      "Crown" ,
      "Dulux",
      "Farrow & Ball"
    ]
  },
  "Flooring": {
    "Carpet": [
      "Corma Carpets"
    ],
    "Ceramic Tiles": [
      "HR Johnson",
      "Porcelanosa",
      "Saloni"
    ],
    "Concrete": [],
    "Laminate": [],
    "Stone": [],
    "Vinyl": [],
    "Wood":[]
  },
  "Sanitaryware": {
    "Basin": [
      "Ideal Standard",
      "Roca",
      "Kohler"
    ],
    "Basin Tap": [
      "Bristan",
      "Franke",
      "Grohe"
    ],
    "Bath": [],
    "Bath Screen": [],
    "Bath Tap/Mixer": [],
    "Shower Head": [],
    "Shower Tray": [],
    "Shower Unit": [
      "Mira",
      "Aqualisa",
      "Triton"
    ],
    "Shower Screen/Door": [],
    "Vanity Cabinet": [],
    "WC": []
  },
  "Worktop": {
    "Composite Stone": [
      "Symphony",
      "Moores",
      "Wren"
    ],
    "Corian": [],
    "Glass": [],
    "Granite": [],
    "Laminate": [],
    "Quartz": [],
    "Silestone": [],
    "Stainless Steel": [],
    "Wood": []
  },
  "Cabinet": {
     "Corner": [
       "Symphony",
       "Moores",
       "Wren"
     ],
     "Island": [],
     "Floor": [],
     "Tall": [],
     "Wall": []
  },
  "Handles": {
    "Stainless Steel": [
      "Symphony",
      "Moores"
    ],
    "Brushed Steel": [],
    "Plastic": [],
    "Polished Chrome": [],
    "Pewter": [],
    "Aluminium": [],
    "Brushed Nickel": []
  },
  "Tap": {
    "Dual": [
      "Bristan",
      "Franke",
      "Blanco",
      "CDA",
      "Astracast",
      "Grohe"
    ],
    "Mixer": [],
    "Monobloc": []
  },
  "Sink": {
    "Stainless Steel": [
      "Blanco",
      "Franke",
      "Reginox",
      "Astracast"
    ],
    "Ceramic": [],
    "Quartz": [],
    "Glass": [],
    "Resin": []
  },
  "Exterior": {
    "Bricks": [
      "Hanson",
      "Ibstock",
      "Wienerberger"
    ],
    "Feature Bricks": [
      "Hanson",
      "Ibstock",
      "Wienerberger"
    ],
    "Roof Tiles": [
      "Hanson",
      "Ibstock",
      "Wienerberger"
    ],
    "Rainwater Goods": [
      "Wavin"
    ],
    "Windows": [
        "Wavin"
    ],
    "Door (Front)": [
        "Wavin"
    ],
    "Door (Garage)": [
        "Wavin"
    ],
    "Door (Patio)": [
        "Wavin"
    ],
    "Door (Rear)": [
        "Wavin"
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
      finish_type.save!
    end

    finish_category.finish_types << finish_type

    manufacturers.each do |manufacturer_name|
      manufacturer = Manufacturer.find_or_initialize_by(name: manufacturer_name)

      if manufacturer.new_record?
        puts "Manufacturer: #{manufacturer.name}" if Features.seed_output
        manufacturer.save!
      end

      finish_type.manufacturers << manufacturer
    end
  end
end

######################################
# Appliances and their Manufacturers #
######################################
{
  "Washing Machine": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zannussi",
    "Siemens"
  ],
  "Washer Dryer": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Tumble Dryer": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Fridge": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Freezer": [
  "AEG",
  "Bosch",
  "Miele",
  "Samsung",
  "Zanussi",
  "Siemens"
  ],
  "Fridge Freezer": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Dishwasher": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Oven": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Hob": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Extractor": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Wine Cooler": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Coffee Machine": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Warming Drawer": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Microwave": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ],
  "Combi Microwave": [
    "AEG",
    "Bosch",
    "Miele",
    "Samsung",
    "Zanussi",
    "Siemens"
  ]
}.each_pair do |category_name, manufacturers|
  appliance_category = ApplianceCategory.find_or_initialize_by(name: category_name)

  if appliance_category.new_record?
    puts "Appliance: #{appliance_category.name}" if Features.seed_output
    appliance_category.save!
  end

  manufacturers.each do |manufacturer_name|
    manufacturer = Manufacturer.find_or_initialize_by(name: manufacturer_name)

    if manufacturer.new_record?
      puts "Manufacturer: #{manufacturer.name}" if Features.seed_output
      manufacturer.save!
    end

    appliance_category.manufacturers << manufacturer
  end
end
