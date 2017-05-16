# frozen_string_literal: true
module DeveloperFixture
  module_function

  def update_attrs
    {
      email: "hamble.developers@example.com",
      contact_number: "07713538572"
    }
  end

  def about
    <<~ABOUT
      Established in 1977. Hamble Developments have been serving the local area
      with exceptional housing that combines the maritime location with comfortable living.
    ABOUT
  end

  def developer_address_attrs
    {
      postal_name: "Langosh Fort",
      building_name: "Mega Building",
      road_name: "Swampy Road",
      city: "Wadeland",
      county: "Gibsonton",
      postcode: "RG13 5HY"
    }
  end

  def updated_company_name
    "Hamble View LTD"
  end

  DEFAULT_FAQS = [
    {
      question: "What does FAQ stand for?",
      answer: "Forgo armadillo quilts.",
      category: "urgent"
    }, {
      question: "How long is a pomodoro?",
      answer: "25 minutes.",
      category: "troubleshooting"
    }
  ].freeze

  def create_default_faqs
    DEFAULT_FAQS.each { |attrs| FactoryGirl.create(:default_faq, attrs) }
  end

  def default_faqs
    category_scope = "activerecord.attributes.faq.categories"

    DEFAULT_FAQS.map do |faq|
      [faq[:question], I18n.t(".#{faq[:category]}", scope: category_scope)]
    end
  end

  def api_key
    "dummy-54321-key"
  end
end
