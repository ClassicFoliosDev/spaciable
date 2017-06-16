#################################
# Manufacturers and their links #
#################################
manufacturers_and_links = {
  "ATAG" => "http://atagheating.co.uk/warranty-register/",
  "AEG" => "http://www.aeg.co.uk/mypages/register-a-product/",
  "Baumatic" => "https://olr.domesticandgeneral.com/app/pages/ApplicationPage.aspx?country=gb&lang=en&brand=BAUM~",
  "Beko" => "http://www.beko.co.uk/register",
  "Bosch" => "http://www.bosch-home.co.uk/register-your-appliance.html",
  "Caple" => "http://www.caple.co.uk/special/guarantee/~",
  "CDA" => "http://www.cda.eu/register-appliance/",
  "Electrolux" => "http://www.electrolux.co.uk/mypages/register-a-product/",
  "Elica" => "http://elica.com/GB-en/register-your-product",
  "Fisher & Paykel" => "https://www.fisherpaykel.com/uk/support/product-registration/",
  "Franke" => "https://www.frankefilterflow.co.uk/productregistration/",
  "Gaggenau" => "https://secure-store.gaggenau.com/gb/myaccount/login",
  "Gorenje" => "http://www.gorenje.co.uk/support/guarantee/register-your-guarantee",
  "Hotpoint" => "http://www.hotpoint.co.uk/register/register-my-appliance.content.html",
  "Indesit" => "https://register.indesit.com/app/pages/ApplicationPage.aspx?country=gb&lang=en&brand=INDE",
  "InSinkerator" => "http://info.insinkerator.co.uk/product-registration",
  "Kuppersbusch" => nil,
  "LG" => "https://www.lg.com/us/support/mylg/product-registration",
  "Liebherr" => "http://www.myliebherr.co.uk/liebherrowners/registerguaranteeform",
  "Miele"=> "https://shop.miele.co.uk/promotions/amdea/",
  "Neff" => "http://www.neff.co.uk/register-your-appliance.html",
  "Quooker" => "http://www.quooker.co.uk/enuk/register-your-quooker",
  "Range Master" => "http://www.rangemaster.co.uk/rangemaster-owners/warranty-registration",
  "Samsung" => "http://www.samsung.com/us/support/register/product",
  "Siemens" => "http://www.siemens-home.bsh-group.com/uk/2_year_guarantee_registration",
  "Smeg" => "https://www.smeg-service.co.uk/smegWarranty/Create",
  "Sub-Zero" => "http://www.subzero-wolf.co.uk/register_product.aspx",
  "V-Zug" => "https://www.vzug.com/gb/en/warrantyregistration?execution=e1s1",
  "Westin" => "http://www.westin.co.uk/support/guarantee-and-after-sales-service/",
  "Whirlpool" => "https://www.whirlpool.co.uk/support/register-your-product-for-free.content.html",
  "White Knight" => "http://www.whiteknightrange.co.uk/warranty/",
  "Zanussi" => "http://www.zanussi.co.uk/support/register-products/"
}.each_pair do |manufacturer_name, link|
  manufacturer = Manufacturer.find_or_initialize_by(name: manufacturer_name, link: link)

  if manufacturer.new_record?
    puts "Manufacturer: #{manufacturer_name} #{link}"
  end

  manufacturer.save!
end

######################################
# Appliances and their Manufacturers #
######################################
all_manufactuers = Manufacturer.where(name: manufacturers_and_links.keys).to_a
[
  "Washing Machine",
  "Washer Dryer",
  "Tumble Dryer",
  "Fridge",
  "Freezer",
  "Fridge Freezer",
  "Dishwasher",
  "Oven",
  "Hob",
  "Extractor",
  "Wine Cooler",
  "Coffee Machine",
  "Warming Drawer",
  "Microwave",
  "Combi Microwave",
].map { |name| ApplianceCategory.find_or_create_by(name: name) }.each do |appliance_category|
  missing_manufacturers = all_manufactuers - appliance_category.manufacturers

  if missing_manufacturers.count.positive?
    appliance_category.manufacturers << missing_manufacturers
    puts "Added #{missing_manufacturers.count} manufacturers to appliance: #{appliance_category.name}"
  end
end
