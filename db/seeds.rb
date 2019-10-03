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

puts "Seeding Database"

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
end

load(Rails.root + "db/seeds/default_faqs.rb")
load(Rails.root + "db/seeds/default_spanish_faqs.rb")
load(Rails.root + "db/seeds/manufacturers_and_appliance_seeds.rb")
load(Rails.root + "db/seeds/finishes_seeds.rb")
load(Rails.root + "db/seeds/how_to_sub_category_seeds.rb")
load(Rails.root + "db/seeds/settings_seeds.rb")

