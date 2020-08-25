
Country.find_by(name: "UK")&.update_attributes(time_zone: "London")
# Spain uses 2 zones - but mostly CET like Paris
Country.find_by(name: "Spain")&.update_attributes(time_zone: "Paris")
