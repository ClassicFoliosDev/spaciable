# frozen_string_literal: true
class CloneDefaultFaqsJob < ApplicationJob
  queue_as :admin

  def perform(faqable_type:, faqable_id:)
    ActiveRecord::Base.connection_pool.with_connection do
      model = faqable_type.constantize.find(faqable_id)
      existing_questions = model.faqs.pluck(:question)

      default_faq_attributes.each do |default_faq|
        next if existing_questions.include?(default_faq[:question])
        model.faqs.create(default_faq)
      end
    end
  end

  private

  def default_faq_attributes
    DefaultFaq.all.map do |default_faq|
      {
        question: default_faq.question,
        answer: default_faq.answer,
        category: default_faq.category
      }
    end
  end
end
