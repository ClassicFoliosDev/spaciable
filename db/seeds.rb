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

if DefaultFaq.none?
  load(Rails.root + "db/seeds/default_faqs.rb")
end


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

  resident = Resident.find_by(email: resident_email) || Resident.first

  if resident.plot.nil?
    puts "Creating plot for resident #{resident.email}"
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


load(Rails.root + "db/seeds/manufacturers_and_appliance_seeds.rb")
load(Rails.root + "db/seeds/finishes_seeds.rb")
load(Rails.root + "db/seeds/how_to_sub_category_seeds.rb")
load(Rails.root + "db/seeds/services_seeds.rb")
