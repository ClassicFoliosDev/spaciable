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
