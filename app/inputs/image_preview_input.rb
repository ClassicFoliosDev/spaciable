# frozen_string_literal: true
class ImagePreviewInput < SimpleForm::Inputs::FileInput
  def input(_wrapper_options = nil)
    # :preview_version is a custom attribute from :input_html hash, so you can pick custom sizes
    input_html_classes.push("hidden")
    build_input(ActiveSupport::SafeBuffer.new)
  end

  private

  def build_input(out)
    # check if there's an uploaded file (eg: edit mode or form not saved)
    # append preview image to output
    if object.send("#{attribute_name}?")
      out << image_preview
      out << content_tag(:br)
    end

    # allow multiple submissions without losing the tmp version
    out << @builder.hidden_field("#{attribute_name}_cache")

    label_text = t("simple_form.inputs.image_preview.upload")
    out << @builder.label(attribute_name, label_text, class: "btn")
    out << @builder.file_field(attribute_name, input_html_options)
  end

  def image_preview
    version = input_html_options.delete(:preview_version)
    url = object.send(attribute_name).tap { |o| break o.send(version) if version }.send("url")
    template.image_tag(url)
  end
end
