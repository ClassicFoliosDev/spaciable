
uk = Country.find_by(name: "UK")
spain = Country.find_by(name: "Spain")
residential = ConstructionType.create(construction: "residential")
commercial = ConstructionType.create(construction: "commercial")
homeowner = "Homeowner"

# Up until this point, all FAQs and default_typeFAQs in the database will have
# one of 6 categories as default_typeined in an ENum
#
# settling
# home
# troubleshooting
# urgent
# general
# purchasing
#
# In this migration, new categories are introduced but no
# existing record references them.  The migration moves
# away from an ENum into a FAQCategory table.  The FAQCategory
# table contains the FULL NAME of the category as opposed
# to the enum ie it will contain "Settling In" instead of "settling"
#
# The migration needs to identify the old enum name against a
# new FULL name so that the new FAQ_Type_Category records can
# be created correctly.  So we need to default_typeine a reference table
cat_names = { "settling" => "Settling In",
              "home" => "Home Care",
              "troubleshooting" => "Troubleshooting",
              "urgent" => "Urgent",
              "general" => "General",
              "purchasing" => "Purchasing Process"
            }

cat_nums = { 0 => cat_names["settling"],
             1 => cat_names["home"],
             2 => cat_names["troubleshooting"],
             3 => cat_names["urgent"],
             4 => cat_names["general"],
             10 => cat_names["purchasing"]
           }

[
  {:name => homeowner,
   :icon => "home",
   :construction_type => residential,
   :country => uk,
   :categories => [cat_names["settling"],
                   cat_names["home"],
                   cat_names["troubleshooting"],
                   cat_names["urgent"],
                   cat_names["general"],
                   "Reservation"],
    :default_type => true
  },
  {:name => homeowner,
   :icon => "home",
   :construction_type => residential,
   :country => spain,
   :categories => [cat_names["settling"],
                   cat_names["home"],
                   cat_names["troubleshooting"],
                   cat_names["urgent"],
                   cat_names["general"],
                   cat_names["purchasing"],
                   "Reservation"],
    :default_type => true
  },
  {:name => "Tenant",
   :icon => "user",
   :construction_type => residential,
   :country => uk,
   :categories => ["Settling In",
                   "Home Care",
                   "Troubleshooting",
                   "Urgent",
                   "General"],
    :default_type => false
  },
  {:name => "Tenant",
   :icon => "user",
   :construction_type => residential,
   :country => spain,
   :categories => ["Settling In",
                   "Home Care",
                   "Troubleshooting",
                   "Urgent",
                   "General"],
    :default_type => false
  },
  {:name => "Commercial",
   :icon => "building",
   :construction_type => commercial,
   :country => uk,
   :categories => ["Health and Safety",
                   "Building Maintenance",
                   "Management",
                   "Troubleshooting",
                   "Urgent",
                   "General"],
    :default_type => false
  },
  {:name => "Commercial",
   :icon => "building",
   :construction_type => commercial,
   :country => spain,
   :categories => ["Health and Safety",
                   "Building Maintenance",
                   "Management",
                   "Troubleshooting",
                   "Urgent",
                   "General"],
    :default_type => false
  }
].each do |faq_type|
  # Create the FAQ Type
  type = FaqType.create(name: faq_type[:name],
                        icon: faq_type[:icon],
                        construction_type: faq_type[:construction_type],
                        country: faq_type[:country],
                        default_type: faq_type[:default_type])

  # Create categories and cross refs
  faq_type[:categories].each do |category|
    category = FaqCategory.find_or_create_by(name: category)
    FaqTypeCategory.create(faq_type: type, faq_category: category)
  end
end

# default_type FAQs replace category and country columns with
# a reference to the faq_type and category rows that
# provides country/category/faq_type/construction data
# All current FAQs will be "homeowner"
DefaultFaq.all.each do |faq|
  # Find the FAQType
  type = FaqType.find_by(name: homeowner, country_id: faq.country_id)
  category = FaqCategory.find_by(name: cat_names[faq.category])
  faq.update_attributes(faq_type: type, faq_category: category)
end

# FAQs replace category and country columns with
# a reference to the faq_type and category rows that
# provides country/category/faq_type data
# All current FAQs will be "homeowner"
Faq.all.each do |faq|
  # Find the FAQType
  type = FaqType.find_by(name: homeowner, country: faq.country)
  category = FaqCategory.find_by(name: cat_nums[faq.category])
  faq.update_attributes(faq_type: type, faq_category: category)
end
