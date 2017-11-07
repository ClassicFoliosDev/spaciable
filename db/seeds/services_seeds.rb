STDOUT.puts <<-INFO
   Creating homeowner services
INFO

Service.find_or_create_by(name: "Financial services", description: "Mortgage brokers, solicitors")
Service.find_or_create_by(name: "Utilities", description: "TV (Digital ariel, satellite, cable), Broadband, electricity, gas, water, telephone, residential parking permits")
Service.find_or_create_by(name: "Insurance", description: "Building, content, car, security")
Service.find_or_create_by(name: "Removals", description: "Removal firms, packing services")
Service.find_or_create_by(name: "Maintenance providers", description: "Landscaping, interior designers, electricians, plumbers, builders, conservatory suppliers, gardeners, window cleaners")
Service.find_or_create_by(name: "Other services", description: "Security systems, IOT (Smart home) provider, furniture packs, appliances, change of address service")

STDOUT.puts <<-INFO
   Finished creating homeowner services
INFO
