# frozen_string_literal: false
module BrandsHelper
  def branded_color_preview(attribute_color)
    styles = "border-color: #{attribute_color};" if attribute_color
    css_classes = "color-circle "
    css_classes << "color-stripe" unless attribute_color.present?

    color_value = attribute_color

    content_tag(:span, "", title: color_value, class: css_classes, style: styles)
  end
end
