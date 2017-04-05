# frozen_string_literal: true
class CloneDefaultFaqsJob < ApplicationJob
  queue_as :admin

  def perform(faqable_type:, faqable_id:)
    ActiveRecord::Base.connection_pool.with_connection do
      model = faqable_type.constantize.find(faqable_id)
      default_faqs = DefaultFaq.all.map do |default_faq|
        {
          question: default_faq.question,
          answer: default_faq.answer,
          category: default_faq.category
        }
      end

      model.faqs.create(default_faqs)
    end
  end
end
