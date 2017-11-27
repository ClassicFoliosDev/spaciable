STDOUT.puts <<-INFO
   Creating homeowner services
INFO

financial_services = Service.find_by(name: "Financial services")
financial_services.update_attributes(name: "Financial Services") if financial_services

other_services = Service.find_by(name: "Other services")
other_services.update_attributes(name: "Other Services", description: "Security systems, internet of things (smart home) providers, furniture packs, appliances, change of address service") if other_services

utilities = Service.find_by(name: "Utilities")
utilities.update_attributes(description: "TV (digital aeriel, satellite, cable), broadband, electricity, gas, water, telephone, residential parking permits") if utilities

Service.find_or_create_by(name: "Financial Services", description: "Mortgage brokers, solicitors")
Service.find_or_create_by(name: "Utilities", description: "TV (digital aeriel, satellite, cable), broadband, electricity, gas, water, telephone, residential parking permits")
Service.find_or_create_by(name: "Insurance", description: "Building, content, car, security")
Service.find_or_create_by(name: "Removals", description: "Removal firms, packing services")
Service.find_or_create_by(name: "Maintenance providers", description: "Landscaping, interior designers, electricians, plumbers, builders, conservatory suppliers, gardeners, window cleaners")
Service.find_or_create_by(name: "Other Services", description: "Security systems, internet of things (smart home) providers, furniture packs, appliances, change of address service")

STDOUT.puts <<-INFO
   Finished creating homeowner services
INFO
