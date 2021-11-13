# frozen_string_literal: true

module DefaultFaqHelper
  def default_faq_packages_collection
    DefaultFaq.faq_packages.reject { |_, v| v == DefaultFaq.faq_packages[:custom] }
              .map do |package_name, _package_int|
      [t("faq_package.#{package_name}"), package_name]
    end
  end
end
