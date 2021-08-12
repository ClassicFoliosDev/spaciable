# frozen_string_literal: true

module FaqsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  FAQTYPERESOURCES ||= {
    homeowner: "Homeowner",
    tenant: "Tenant",
    commercial: "Commercial"
  }

  FAQCATEGORYRESOURCES ||= {
    settling: "Settling In",
    home:  "Home Care",
    troubleshooting: "Troubleshooting",
    urgent: "Urgent",
    general: "General",
    reservation: "Reservation",
    purchasing: "Purchasing Process",
    health_and_safety: "Health and Safety",
    maintainence: "Building Maintenance",
    management: "Management"
  }

  FAQTYPERESOURCES.each_pair do |resource, name|
    define_method "#{resource}_name" do
      name
    end

    define_method "#{resource}" do |country=CreateFixture.uk|
      FaqType.find_by(name: name, country: country)
    end
  end

  FAQCATEGORYRESOURCES.each_pair do |resource, name|
    define_method "#{resource}_name" do
      name
    end

    define_method "#{resource}" do
      FaqCategory.find_by(name: name)
    end
  end

  def default_faq_attrs
    [
      { country: CreateFixture.uk,
        type: homeowner,
        created: {
          question: "How fast does a swallow fly?",
          answer: "Roughly 11 meters per second.",
          category: general
        },
        updated: {
          question: "What does this second turtle stand on?",
          answer: "It's turtles all the way down.",
          category: urgent
        }
      },
      { country: CreateFixture.uk,
        type: tenant,
        created: {
          question: "How slow does an elephant fly?",
          answer: "There aren't wings big enough.",
          category: troubleshooting
        },
        updated: {
          question: "What time is dinner?",
          answer: "dinner time.",
          category: urgent
        }
      },
      { country: CreateFixture.uk,
        type: commercial,
        created: {
          question: "How deep is the hole?",
          answer: "A whole lot.",
          category: management
        },
        updated: {
          question: "What time is tea?",
          answer: "tea time.",
          category: maintainence
        }
      },
      { country: CreateFixture.spain,
        type: homeowner,
        created: {
          question: "How fast does a swallow fly?",
          answer: "Roughly 11 meters per second.",
          category: general
        },
        updated: {
          question: "What does this second turtle stand on?",
          answer: "It's turtles all the way down.",
          category: purchasing
        }
      },
      { country: CreateFixture.spain,
        type: tenant,
        created: {
          question: "How slow does an elephant fly?",
          answer: "There aren't wings big enough.",
          category: troubleshooting
        },
        updated: {
          question: "What time is dinner?",
          answer: "dinner time.",
          category: urgent
        }
      },
      { country: CreateFixture.spain,
        type: commercial,
        created: {
          question: "How much came out the hole?",
          answer: "A whole lot.",
          category: management
        },
        updated: {
          question: "What time is tea?",
          answer: "tea time.",
          category: maintainence
        }
      }
    ]
  end

  def faq_attrs
    {
      developer: {
        created: {
          question: "How fast does a swallow fly?",
          answer: "Roughly 11 meters per second.",
          faq_type: homeowner,
          faq_category: general
        },
        updated: {
          question: "What does this second turtle stand on?",
          answer: "It's turtles all the way down.",
          faq_type: homeowner,
          faq_category: urgent
        }
      },
      division: {
        created: {
          question: "How many lightbulbs does it take to change a light bulb?",
          answer: "Uhhhh. 42!",
          faq_type: tenant,
          faq_category: general
        },
        updated: {
          question: "What is the meaning of life?",
          answer: "Ruby on Rails :robot:",
          faq_type: tenant,
          faq_category: urgent
        }
      },
      development: {
        created: {
          question: "How do I deal with noisy neighbours?",
          answer: "Save up for a house in rural location.",
          faq_type: homeowner,
          faq_category: general
        },
        updated: {
          question: "How do I be a good neighbour?",
          answer: "Always keep a *full* cup of sugar near the front door.",
          faq_type: homeowner,
          faq_category: urgent
        }
      },
      division_development: {
        created: {
          question: "What pets can I keep?",
          answer: "Nothing genetically modified or cloned.",
          faq_type: tenant,
          faq_category: general
        },
        updated: {
          question: "Can I keep runner ducks on the property?",
          answer: "Firstly, please register your duck online...",
          faq_type: tenant,
          faq_category: urgent
        }
      }
    }
  end

  def create_developer_division_development_divdevelopment
    create_developer
    create_division
    create_development
    create_division_development
  end

  def create_faqs_for(additional, resource = :developer)
    resource_name = ResourceName(resource).to_sym

    attrs = faq_attrs.select { |(key, _)| key == resource_name }
    create_faqs(additional, attrs)
  end

  def create_faqs(additional, attrs_scope = faq_attrs)
    attrs_scope.each_pair do |faqable, actions|
      actions.select { |key, _| key == :created }.each do |_, attrs|
        resource = AdditionalRoleFixture.resource(additional, faqable)
        faq_attrs = attrs.merge(faqable: resource)

        FactoryGirl.create(:faq, faq_attrs)
      end
    end
  end

  def attrs(action = "created", parent = nil, under: :developer)
    resource_name = ResourceName(under, parent)
    faq_attrs[resource_name.to_sym][action.to_sym]
  end

  def faq_id(additional, parent = nil, under: :developer, updated: false)
    resource_name = ResourceName(under, parent)

    action = updated ? :updated : :created
    question = faq_attrs.fetch(resource_name.to_sym).dig(action, :question)

    Faq.find_by(question: question, faqable: AdditionalRoleFixture.resource(additional, resource_name)).id
  end

  def edited_question
    "How do you change an FAQ?"
  end

  def edited_answer
    "You're here forever"
  end

  def development2_name
    "Water Meadows"
  end

  def development3_name
    "Flood Plain"
  end

  # create the reference data that supports faqs.
  def create_faq_ref
    CreateFixture.create_countries
    create_constructions
    create_faq_types
    create_faq_categories
    create_faq_type_categories
  end

  def create_faq
    create_faq_ref
    FactoryGirl.create(:faq, question: CreateFixture.faq_name, faqable: CreateFixture.developer, faq_type: homeowner, faq_category: settling)
  end

  def create_faq_types
    return if FaqType.count.positive?
    CreateFixture.create_countries
    create_constructions
    FactoryGirl.create(:faq_type, name: homeowner_name, icon: "home", default_type: true, country: CreateFixture.uk, construction_type: residential_c)
    FactoryGirl.create(:faq_type, name: homeowner_name, icon: "home", default_type: true, country: CreateFixture.spain, construction_type: residential_c)
    FactoryGirl.create(:faq_type, name: tenant_name, icon: "user", default_type: false, country: CreateFixture.uk, construction_type: residential_c)
    FactoryGirl.create(:faq_type, name: tenant_name, icon: "user", default_type: false, country: CreateFixture.spain, construction_type: residential_c)
    FactoryGirl.create(:faq_type, name: commercial_name, icon: "user", default_type: false, country: CreateFixture.uk, construction_type: commercial_c)
    FactoryGirl.create(:faq_type, name: commercial_name, icon: "user", default_type: false, country: CreateFixture.spain, construction_type: commercial_c)
  end

  def create_faq_categories
    return if FaqCategory.count.positive?
    FAQCATEGORYRESOURCES.each_pair do |resource, name|
      FactoryGirl.create(:faq_category, name: name)
    end
  end

  def create_faq_type_categories
    return if FaqTypeCategory.count.positive?
    # uk homeowner
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: settling)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: home)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner, faq_category: reservation)
    # spain homeowner
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: settling)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: home)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: reservation)
    FactoryGirl.create(:faq_type_category, faq_type: homeowner(CreateFixture.spain), faq_category: purchasing)
    # uk tenant
    FactoryGirl.create(:faq_type_category, faq_type: tenant, faq_category: settling)
    FactoryGirl.create(:faq_type_category, faq_type: tenant, faq_category: home)
    FactoryGirl.create(:faq_type_category, faq_type: tenant, faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: tenant, faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: tenant, faq_category: general)
    # spain tenant
    FactoryGirl.create(:faq_type_category, faq_type: tenant(CreateFixture.spain), faq_category: settling)
    FactoryGirl.create(:faq_type_category, faq_type: tenant(CreateFixture.spain), faq_category: home)
    FactoryGirl.create(:faq_type_category, faq_type: tenant(CreateFixture.spain), faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: tenant(CreateFixture.spain), faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: tenant(CreateFixture.spain), faq_category: general)
    # uk commercial
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: health_and_safety)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: maintainence)
    FactoryGirl.create(:faq_type_category, faq_type: commercial, faq_category: management)
    # spain commercial
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: troubleshooting)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: urgent)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: general)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: health_and_safety)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: maintainence)
    FactoryGirl.create(:faq_type_category, faq_type: commercial(CreateFixture.spain), faq_category: management)
   end

  def create_constructions
    return if ConstructionType.count.positive?
    FactoryGirl.create(:construction_type, construction: ConstructionType.constructions[:residential])
    FactoryGirl.create(:construction_type, construction: ConstructionType.constructions[:commercial])
  end

  def residential_c
    ConstructionType.find_by(construction: ConstructionType.constructions[:residential])
  end

  def commercial_c
    ConstructionType.find_by(construction: ConstructionType.constructions[:commercial])
  end

  def cc_emails
    "cc@first.com cc@second.com; cc@third.com, cc@forth.com"
  end
end
