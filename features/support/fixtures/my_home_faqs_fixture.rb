# frozen_string_literal: true

module MyHomeFaqsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def faqs
    [
      {
        question: "How do I unlock the front door?",
        answer: "Your doorman will do this for you.",
        faqable: -> { developer },
        type: FaqsFixture.homeowner,
        category: FaqsFixture.urgent
      },
      {
        question: "Where do you keep the chauffeurs?",
        answer: "Simply use the chauffeur app on you phone to locate them.",
        faqable: -> { developer },
        type: FaqsFixture.homeowner,
        category: FaqsFixture.settling
      },
      {
        question: "What day is pancake day?",
        answer: "Everyday if you wish.",
        faqable: -> { development },
        type: FaqsFixture.tenant,
        category: FaqsFixture.troubleshooting
      },
      {
        question: "Was it the butler in the garage with the frying pan?",
        answer: "Cluedo!",
        faqable: -> { development },
        type: FaqsFixture.tenant,
        category: FaqsFixture.general
      },
      {
        question: "Can we get settled?",
        answer: "Yes we can.",
        faqable: -> { developer },
        type: FaqsFixture.homeowner,
        category: FaqsFixture.settling
      }
    ]
  end

  def create_homeowner_faqs
    FaqsFixture.create_faq_ref
    create_developer
    create_development
    create_resident_and_phase
    create_faqs
  end

  def create_resident
    FactoryGirl.create(:resident, :with_residency, plot: development_plot, email: resident_email, ts_and_cs_accepted_at: Time.zone.now)
  end

  def resident_email
    "resident@example.com"
  end

  def resident
    Resident.find_by(email: resident_email)
  end

  def create_faqs
    faqs.each do |attrs|
      FactoryGirl.create(
        :faq,
        question: attrs[:question],
        answer: attrs[:answer],
        faqable: attrs[:faqable].call,
        faq_type: attrs[:type],
        faq_category: attrs[:category]
      )
    end
  end

   def default_type_name
    FaqsFixture.homeowner.name
  end

  def default_category_name
    FaqsFixture.settling.name
  end

  def other_category_name
    FaqsFixture.urgent.name
  end

  def recent_faqs
    all_faqs.reverse.take(5)
  end

  def default_filtered_faqs
    faqs.select { |attrs| attrs[:category] == FaqsFixture.settling }.map(&method(:front_end_attrs))
  end

  def default_filtered_out_faqs
    all_faqs - default_filtered_faqs
  end

  def filtered_faqs
    faqs.select { |attrs| attrs[:category] == FaqsFixture.urgent }.map(&method(:front_end_attrs))
  end

  def filtered_out_faqs
    all_faqs - filtered_faqs
  end

  private

  module_function

  def all_faqs
    faqs.map(&method(:front_end_attrs))
  end

  def front_end_attrs(attrs)
    [attrs[:question], attrs[:answer]]
  end
end
