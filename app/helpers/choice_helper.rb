# frozen_string_literal: true

module ChoiceHelper
  def choice_options_collection
    Development.choice_options.map do |(choice_label, _choice_label_int)|
      [t(choice_label, scope: choice_label_scope), choice_label]
    end
  end

  private

  def choice_label_scope
    "activerecord.attributes.developer.choice_labels"
  end
end
