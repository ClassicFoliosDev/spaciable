# frozen_string_literal: true

require "rails_helper"

RSpec.describe CloneDefaultFaqsJob do
  it "should clone the Default Faqs for the supplied faqable model" do
    developer = create(:developer)
    default_faqs = create_list(:default_faq, 5)

    expect do
      described_class.perform_now(faqable_type: "Developer", faqable_id: developer.id)
    end.to change { developer.faqs.count }.by(default_faqs.count)
  end

  describe "to allow user to run the seeds more than once" do
    it "should not create duplicate FAQs on consecutive runs" do
      developer = create(:developer)
      clone_default_faqs = -> { described_class.perform_now(faqable_type: "Developer", faqable_id: developer.id) }

      create_list(:default_faq, 5)
      clone_default_faqs.call
      create(:default_faq)

      expect do
        clone_default_faqs.call
      end.to change { developer.faqs.count }.by(1)
    end
  end
end
