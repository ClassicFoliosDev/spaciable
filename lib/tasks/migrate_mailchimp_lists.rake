# frozen_string_literal: true

namespace :mailchimp do
  def migrate_lists(logger)
    ActiveRecord::Base.transaction do
      Developer.all.each do |developer|
        next unless developer.api_key?
        @gibbon = MailchimpUtils.client(developer.api_key)

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

  rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
    logger.warn("Not able to migrate #{resource.to_s}, probable cause is that the list has been deleted in mailchimp")
    logger.info(e.message)
  end
end
