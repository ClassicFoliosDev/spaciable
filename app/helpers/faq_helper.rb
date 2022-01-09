# frozen_string_literal: true

module FaqHelper
  def faq_help(parent)
    messages = []
    %i[free essentials].each do |package|
      messages << t("faq_package.#{package}_help") if any_phases?(parent, [package])
    end
    messages
  end
end
