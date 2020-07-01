# frozen_string_literal: true

require "rails_helper"

RSpec.describe CloneDefaultFaqsJob do
  it "should clone the Default Faqs for the supplied faqable model" do
    developer = create(:developer)
    type = create(:faq_type)
    cat = create(:faq_category)
    default_faqs = create_list(:default_faq, 5, faq_type: type, faq_category: cat)

    expect do
      described_class.perform_now(faqable_type: "Developer", faqable_id: developer.id, country_id: 1)
    end.to change { developer.faqs.count }.by(default_faqs.count)
  end

  describe "to allow user to run the seeds more than once" do
    it "should not create duplicate FAQs on consecutive runs" do
      developer = create(:developer)
      type = create(:faq_type)
      cat = create(:faq_category)
      clone_default_faqs = -> { described_class.perform_now(faqable_type: "Developer", faqable_id: developer.id, country_id: 1) }

      create_list(:default_faq, 5, faq_type: type, faq_category: cat)
      clone_default_faqs.call
      create(:default_faq, faq_type: type, faq_category: cat)

      expect do
        clone_default_faqs.call
      end.to change { developer.faqs.count }.by(1)
    end
  end
end
