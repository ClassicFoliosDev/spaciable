# frozen_string_literal: true

module FaqPackageEnum
  extend ActiveSupport::Concern

  included do
    enum faq_package: %i[
      standard
      enhanced
      custom
    ]
  end
end
