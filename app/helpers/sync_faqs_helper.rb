# frozen_string_literal: true

module SyncFaqsHelper
  def parent_faq(faq, parent_faqs)
    parent_faqs.find_by(question: faq.question)
  end

  def sync_faq_status(faq, parent_faqs)
    pfaq = parent_faq(faq, parent_faqs)
    return :no_match unless pfaq

    faq_match_type(faq, pfaq)
  end

  # compare the parent faq to the global faq for a title match
  def faq_match_type(faq, pfaq)
    # question and answer match
    return :exact_match if pfaq.answer.strip == faq.answer.strip
    # parent answer has never been updated (legacy global)
    return :answer_legacy if pfaq.created_at == pfaq.updated_at

    # answer had been updated since creation
    :answer_updated
  end
end
