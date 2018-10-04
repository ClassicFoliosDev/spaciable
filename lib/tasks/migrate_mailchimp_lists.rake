# frozen_string_literal: true

namespace :mailchimp do
  desc "add service columns for existing mailchimp lists"
  task migrate_lists_services: :environment do
    log_file = "log/mailchimp_migration.log"
    logger = Logger.new log_file

    logger.info(">>>>>>>> Migrate mailchimp lists <<<<<<<<")
    logger.info "Adding new service columns"

    fields.each do |field|
      logger.info "#{field[:tag]} #{field[:name]}"
    end
    logger.info "=========================="

    migrate_lists(logger)

    logger.info(">>>>>>>> <<<<<<<<")
  end

  def migrate_lists(logger)
    ActiveRecord::Base.transaction do
      Developer.all.each do |developer|
        next unless developer.api_key?
        @gibbon = MailchimpUtils.client(api_key)

        migrate_list(developer, logger)

        developer.divisions.each do |division|
          migrate_list(division, logger)
        end
        logger.info("")

      end
    end
  end

  def migrate_list(resource, logger)
    return if resource.list_id.blank?

    fields.each do |field|
      @gibbon.lists.(resource.list_id).merge_fields.
              create(body: {tag: field[:tag], name: field[:tag], type: field[:type], public: field[:public]})
    end
    logger.info("Migrated #{resource.to_s}")
  end

  def fields
    [{
       name: "Conveyancing and legal",
       tag: "LEGAL",
       type: "text",
       public: true
    },
    {
       name: "Moving manager",
       tag: "MANAGER",
       type: "text",
       public: true
    },
    {
       name: "Mortgages and insurance",
       tag: "FINANCE",
       type: "text",
       public: true
    },
    {
       name: "Removals and storage",
       tag: "REMOVALS",
       type: "text",
       public: true
    },
    {
      name: "Utilities",
      tag: "UTILITIES",
      type: "text",
      public: true
    },
    {
      name: "Selling or renting",
      tag: "ESTATE",
      type: "text",
      public: true
    }]
  end
end
