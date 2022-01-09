# frozen_string_literal: true

class CloneDefaultFaqsJob < ApplicationJob
  queue_as :admin

  def perform(faqable_type:, faqable_id:, country_id:)
    ActiveRecord::Base.connection_pool.with_connection do
      model = faqable_type.constantize.find(faqable_id)
      existing_questions = model.faqs.pluck(:question)

      default_faq_attributes(country_id).each do |default_faq|
        next if existing_questions.include?(default_faq[:question])

        model.faqs.create(default_faq)
      end
    end
  end

  private

  def default_faq_attributes(country_id)
    # get all the faq category types associated with the country
    DefaultFaq.joins(faq_type: :country)
              .where(faq_types: { country_id: country_id }).map do |default_faq|
      {
        question: default_faq.question,
        answer: default_faq.answer,
        category: 0, # This should be removed after successful release #remove
        faq_type: default_faq.faq_type,
        faq_category: default_faq.faq_category,
        faq_package: default_faq.faq_package
      }
    end
  end
end
