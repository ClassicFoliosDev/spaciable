# frozen_string_literal: true
module FaqsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def category(key)
    I18n.t("activerecord.attributes.faq.categories.#{key}")
  end

  FAQ_ATTRS = {
    developer: {
      created: {
        question: "How fast does a swallow fly?",
        answer: "Roughly 11 meters per second.",
        category: category(:general)
      },
      updated: {
        question: "What does this second turtle stand on?",
        answer: "It's turtles all the way down.",
        category: category(:urgent)
      }
    }
  }.freeze

  def setup
    create_developer
    create_division
    create_development
  end

  def create_admin(admin_type = :cf)
    send("create_#{admin_type.to_s.downcase}_admin")
  end

  def create_faqs
    FAQ_ATTRS.each_pair do |faqable, actions|
      actions.select { |key, _| key == :created }.each do |_, attrs|
        resource = send(faqable)
        faq_attrs = attrs.merge(faqable: resource)

        FactoryGirl.create(:faq, faq_attrs)
      end
    end
  end

  def faq_attrs(action = "created", under: :developer)
    FAQ_ATTRS.dig(under.to_sym, action.to_sym)
  end

  def faq_id(under: :developer, updated: false)
    action = updated ? :updated : :created
    question = FAQ_ATTRS.dig(under.to_sym, action, :question)

    Faq.find_by(question: question, faqable: send(under)).id
  end
end
