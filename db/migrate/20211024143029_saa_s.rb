class SaaS < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
         add_column :phases, :package, :integer, default: Phase.packages[:legacy]
         add_column :faqs, :faq_package, :integer, default: Faq.faq_packages[:custom]
         add_column :default_faqs, :faq_package, :integer, default: DefaultFaq.faq_packages[:standard]
         add_column :custom_tiles, :cf, :boolean, default: true

         Rake::Task['faq_package:initialise'].invoke
      }

      direction.down {
        remove_column :phases, :package
        remove_column :faqs, :faq_package
        remove_column :default_faqs, :faq_package
        remove_column :custom_tiles, :cf
      }
    end
  end
end
