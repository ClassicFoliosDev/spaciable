# frozen_string_literal: true

namespace :recreate_versions do
  desc "Recreate all versions"
  task all: %i[documents appliances brands]

  desc "Recreate the preview image for all documents"
  task documents: :environment do
    files = 0
    Document.find_each do |document|
      # Skip carrierwave_backgrounder
      document.process_file_upload = true

      begin
        document.file.recreate_versions! && files += 1 if document.file?
      rescue => e
        puts "Document: #{document.id} (#{document}) Failed: #{e}"
      end
    end

    puts "Completed Documents: #{files}"
  end

  desc "Recreate the images for all appliances"
  task appliances: :environment do
    pimages = 0
    simages = 0
    manuals = 0

    Appliance.find_each do |appliance|
      # Skip carrierwave_backgrounder
      appliance.process_primary_image_upload = true
      appliance.process_secondary_image_upload = true
      appliance.process_manual_upload = true

      begin
        appliance.primary_image.recreate_versions! && pimages += 1 if appliance.primary_image?
      rescue => e
        puts "Appliance Primary Image: #{appliance.id} (#{appliance}) Failed: #{e}"
      end

      begin
        appliance.secondary_image.recreate_versions! && simages += 1 if appliance.secondary_image?
      rescue => e
        puts "Appliance Secondary Image: #{appliance.id} (#{appliance}) Failed: #{e}"
      end

      begin
        appliance.manual.recreate_versions! && manuals += 1 if appliance.manual?
      rescue => e
        puts "Appliance Manual: #{appliance.id} (#{appliance}) Failed: #{e}"
      end
    end

    puts "Completed Appliances Images #{pimages}, 2nd Images #{simages}, Manuals #{manuals}"
  end

  desc "Recreate the images for all appliances"
  task brands: :environment do
    logos = 0
    banners = 0

    Brand.find_each do |brand|
      # Skip carrierwave_backgrounder
      brand.process_logo_upload = true
      brand.process_banner_upload = true

      begin
        brand.logo.recreate_versions! && logos += 1 if brand.logo?
      rescue => e
        puts "Brand Logo: #{brand.id} (#{brand.brandable} Brand) Failed: #{e}"
      end

      begin
        brand.banner.recreate_versions! && banners += 1 if brand.banner?
      rescue => e
        puts "Brand Banner: #{brand.id} (#{brand.brandable} Brand) Failed: #{e}"
      end
    end

    puts "Completed Brands logos #{logos}, banners #{banners}"
  end
end
