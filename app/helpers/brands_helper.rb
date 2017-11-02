# frozen_string_literal: false

module BrandsHelper
  def branded_color_preview(attribute_color)
    styles = "background-color: #{attribute_color};" if attribute_color
    css_classes = "color-circle "
    css_classes << "color-stripe" if attribute_color.blank?

    color_value = attribute_color

    content_tag(:span, "", title: color_value, class: css_classes, style: styles)
  end
end
