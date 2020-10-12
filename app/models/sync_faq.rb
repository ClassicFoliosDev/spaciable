# frozen_string_literal: true

class SyncFaq
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :faqs

  def self.sync_parent_faqs(faq_id, parent)
    faq = DefaultFaq.find_by(id: faq_id)

    # if the global faq (title) exists for the parent then update the parent faq answer
    # otherwise create a new faq for the parent
    if (pfaq = Faq.find_by(faqable: parent, question: faq.question))
      pfaq.update_attributes(answer: faq.answer)
    else
      Faq.create(question: faq.question,
                 answer: faq.answer,
                 category: faq.category,
                 faqable: parent,
                 faq_type_id: faq.faq_type_id,
                 faq_category_id: faq.faq_category_id)
    end
  end
end
