# frozen_string_literal: true

namespace :faq_package do
  task initialise: :environment do
    migrate_faqs
  end

  def migrate_faqs
    Faq.where(faqable_type: ["Development", "Developer"]).update_all(faq_package: Faq.faq_packages[:standard])
  end
end
