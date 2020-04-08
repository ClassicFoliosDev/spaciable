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
      "Victoria Carpets",
      "Cormar Carpets"
    ],
    "Ceramic Tiles": [
      "HR Johnson",
      "Porcelanosa",
      "Saloni"
    ],
    "Concrete": [],
    "Laminate": [
      "Amtico",
      "Karndean"
    ],
    "Stone": [],
    "Vinyl": ["Forbo"],
    "Wood":[]
  },
  "Sanitaryware": {
    "Basin": [
      "Ideal Standard",
      "Roca",
      "Kohler",
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Basin Tap": [
      "Bristan",
      "Franke",
      "Grohe",
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Bath": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Bath Screen": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Bath Tap/Mixer": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Shower Head": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Shower Tray": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode",
      "Just Trays"
    ],
    "Shower Unit": [
      "Mira",
      "Aqualisa",
      "Triton",
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Shower Screen/Door": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ],
    "Vanity Cabinet": [],
    "WC": [
      "Villeroy and Boch",
      "VitrA",
      "Kaldewei",
      "Abode"
    ]
  },
  "Worktop": {
    "Composite Stone": [
      "Symphony",
      "Moores",
      "Wren",
      "Leicht Kitchens"
    ],
    "Corian": ["Leicht Kitchens"],
    "Glass": ["Leicht Kitchens"],
    "Granite": ["Leicht Kitchens"],
    "Laminate": ["Leicht Kitchens"],
    "Quartz": ["Leicht Kitchens"],
    "Silestone": ["Leicht Kitchens"],
    "Stainless Steel": ["Leicht Kitchens"],
    "Wood": ["Leicht Kitchens"]
  },
  "Cabinet": {
     "Corner": [
       "Symphony",
       "Moores",
       "Wren",
       "Leicht Kitchens"
     ],
    "Island": ["Leicht Kitchens"],
    "Floor": ["Leicht Kitchens"],
    "Tall": ["Leicht Kitchens"],
    "Wall": ["Leicht Kitchens"]
  },
  "Handles": {
    "Stainless Steel": [
      "Symphony",
      "Moores",
      "Wren",
      "Leicht Kitchens"
    ],
    "Brushed Steel": [
      "Wren",
      "Leicht Kitchens"
                     ],
    "Plastic": [
      "Wren",
      "Leicht Kitchens"
    ],
    "Polished Chrome": [
      "Wren",
      "Leicht Kitchens"
    ],
    "Pewter": [
      "Wren",
      "Leicht Kitchens"
    ],
    "Aluminium": [
      "Wren",
      "Leicht Kitchens"
     ],
    "Brushed Nickel": [
       "Wren",
       "Leicht Kitchens"
     ]
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
      finish_type.finish_categories = [finish_category]
      finish_type.save!(validate: false)
    end

    manufacturers.each do |manufacturer_name|
      manufacturer = FinishManufacturer.find_or_initialize_by(name: manufacturer_name)
      manufacturer.finish_types << finish_type unless manufacturer.finish_types.include?(finish_type)

      if manufacturer.new_record?
        puts "Manufacturer: #{manufacturer.name}" if Features.seed_output
      end

      manufacturer.save!
    end
  end
end

