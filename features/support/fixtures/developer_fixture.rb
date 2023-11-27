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
      postal_number: "Langosh Fort",
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

  def default_faqs
    [{
      question: "What does FAQ stand for?",
      answer: "Forgo armadillo quilts.",
      faq_type: ::FaqsFixture.homeowner,
      faq_category: FaqsFixture.urgent
    }, {
      question: "How long is a pomodoro?",
      answer: "25 minutes.",
      faq_type: FaqsFixture.homeowner,
      faq_category: FaqsFixture.troubleshooting
    },
    {
      question: "When can I leave?",
      answer: "6 months",
      faq_type: FaqsFixture.tenant,
      faq_category: FaqsFixture.general
    },
    {
      question: "Can I leave in 6 months?",
      answer: "Don't you listen?",
      faq_type: FaqsFixture.tenant,
      faq_category: FaqsFixture.home
    }]
  end

  def create_default_faqs
    FaqsFixture.create_faq_ref
    default_faqs.each do |attrs|
      attrs[:country_id] = CreateFixture.uk.id #remove
      attrs[:category] = 0 #remove
      FactoryGirl.create(:default_faq, attrs)
    end
  end
end
