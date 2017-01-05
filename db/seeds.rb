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
    first_name: "admin",
    last_name: "admin",
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

if Rails.env.development? && User.owner.none?
  homeowner_email = "homeowner@alliants.com"
  homeowner_password = "12345678"

  FactoryGirl.create(:homeowner, email: homeowner_email, password: homeowner_password)

  STDOUT.puts <<-INFO

  #{'*' * 100}
  Homeowner has been added:
    email: #{homeowner_email}
    password: #{homeowner_password}
  #{'*' * 100}

  INFO
end

if HomeownerLoginContent.none?
  content = HomeownerLoginContent.new
  content.title_left = I18n.t('devise.sessions.new.title.left')
  content.title_right = I18n.t('devise.sessions.new.title.right')
  content.blurb_para_1 = I18n.t('devise.sessions.new.intro_para_1')
  content.blurb_para_2 = I18n.t('devise.sessions.new.intro_para_2')
  content.save!
end

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
  finish_category = FinishCategory.find_or_create_by(name: category_name)

  types.each_pair do |type_name, manufacturers|
    finish_type = finish_category.finish_types.find_or_create_by(name: type_name)

    manufacturers.each do |manufacturer_name|
      finish_type.manufacturers.find_or_create_by(name: manufacturer_name)
    end
  end
end

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
  appliance_category = ApplianceCategory.find_or_create_by!(name: category_name)

  manufacturers.each do |manufacturer_name|
    appliance_category.manufacturers.find_or_create_by!(name: manufacturer_name)
  end

end