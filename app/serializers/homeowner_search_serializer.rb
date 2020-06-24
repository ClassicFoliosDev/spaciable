# frozen_string_literal: true

class HomeownerSearchSerializer
  attr_accessor :id, :type, :name, :path

  def self.build(context, results_hash)
    result_list = []
    results_hash.each do |type_key, results|
      result_list += results.map do |result|
        {
          id: result.id,
          type: type_key,
          name: result.to_s,
          path: build_path(context, result, type_key)
        }
      end
    end

    result_list
  end

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def self.build_path(context, result, type)
    case type
    when :Appliance
      context.homeowner_appliances_path
    when :Manual
      context.homeowner_library_path("appliance_manuals")
    when :Finish
      context.homeowner_my_home_path
    when :Room
      context.homeowner_my_home_path
    when :Document
      context.homeowner_library_path(result.category)
    when :Faq
      context.homeowner_faqs_path(result.faq_type_id, result.faq_category_id)
    when :Contact
      context.homeowner_contacts_path(result.category)
    when :HowTo
      context.homeowner_how_tos_path(result.category)
    when :Notification
      context.homeowners_notifications_path
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable MethodLength
end
