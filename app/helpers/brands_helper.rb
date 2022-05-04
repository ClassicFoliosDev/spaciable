# frozen_string_literal: false

module BrandsHelper
  def branded_color_preview(attribute_color)
    styles = "background-color: #{attribute_color};" if attribute_color
    css_classes = "color-circle "
    css_classes << "color-stripe" if attribute_color.blank?

    color_value = attribute_color

    content_tag(:span, "", title: color_value, class: css_classes, style: styles)
  end

  def fonts_collection
    fonts = []

    t("brands.form.fonts").each do |font|
      fonts << [font[:title], font[:font]]
    end
    fonts
  end

  def border_styles_collection
    Brand.border_styles.map do |(key, _)|
      [t("activerecord.attributes.brand.border_styles.#{key}"), key]
    end
  end

  def button_styles_collection
    Brand.button_styles.map do |(key, _)|
      [t("activerecord.attributes.brand.button_styles.#{key}"), key]
    end
  end
end
