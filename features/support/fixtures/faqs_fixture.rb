# frozen_string_literal: true

module FaqsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def t_category(key)
    I18n.t("activerecord.attributes.faq.categories.#{key}")
  end

  FAQ_ATTRS = {
    developer: {
      created: {
        question: "How fast does a swallow fly?",
        answer: "Roughly 11 meters per second.",
        category: :general
      },
      updated: {
        question: "What does this second turtle stand on?",
        answer: "It's turtles all the way down.",
        category: :urgent
      }
    },
    division: {
      created: {
        question: "How many lightbulbs does it take to change a light bulb?",
        answer: "Uhhhh. 42!",
        category: :general
      },
      updated: {
        question: "What is the meaning of life?",
        answer: "Ruby on Rails :robot:",
        category: :urgent
      }
    },
    development: {
      created: {
        question: "How do I deal with noisy neighbours?",
        answer: "Save up for a house in rural location.",
        category: :general
      },
      updated: {
        question: "How do I be a good neighbour?",
        answer: "Always keep a *full* cup of sugar near the front door.",
        category: :urgent
      }
    },
    division_development: {
      created: {
        question: "What pets can I keep?",
        answer: "Nothing genetically modified or cloned.",
        category: :general
      },
      updated: {
        question: "Can I keep runner ducks on the property?",
        answer: "Firstly, please register your duck online...",
        category: :urgent
      }
    }
  }.freeze

  def create_developer_division_development_divdevelopment
    create_developer
    create_division
    create_development
    create_division_development
  end

  def create_faqs_for(resource = :developer)
    resource_name = ResourceName(resource).to_sym

    attrs = FAQ_ATTRS.select { |(key, _)| key == resource_name }
    create_faqs(attrs)
  end

  def create_faqs(attrs_scope = FAQ_ATTRS)
    attrs_scope.each_pair do |faqable, actions|
      actions.select { |key, _| key == :created }.each do |_, attrs|
        resource = send(faqable)
        faq_attrs = attrs.merge(faqable: resource)

        FactoryGirl.create(:faq, faq_attrs)
      end
    end
  end

  def faq_attrs(action = "created", parent = nil, under: :developer)
    resource_name = ResourceName(under, parent)

    FAQ_ATTRS.fetch(resource_name.to_sym).fetch(action.to_sym)
  end

  def faq_id(parent = nil, under: :developer, updated: false)
    resource_name = ResourceName(under, parent)

    action = updated ? :updated : :created
    question = FAQ_ATTRS.fetch(resource_name.to_sym).dig(action, :question)

    Faq.find_by(question: question, faqable: send(resource_name)).id
  end

  def edited_question
    "How do you change an FAQ?"
  end

  def development2_name
    "Water Meadows"
  end

  def development3_name
    "Flood Plain"
  end
end
