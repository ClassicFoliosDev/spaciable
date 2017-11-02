# frozen_string_literal: true

module TranslationHelper
  def t_enum(model, attribute, key)
    return "" if key.nil?

    model_name = model.model_name.i18n_key

    t("activerecord.attributes.#{model_name}.#{attribute.to_s.pluralize}.#{key.to_sym}")
  end
end
