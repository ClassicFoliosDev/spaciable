# frozen_string_literal: true
class ImagePreviewInput < SimpleForm::Inputs::FileInput
  def input(_wrapper_options = nil)
    # :preview_version is a custom attribute from :input_html hash, so you can pick custom sizes
    input_html_classes.push("file-upload")
    build_input(ActiveSupport::SafeBuffer.new)
  end

  private

  def build_input(out)
    build_preview(out)
    build_buttons(out)

    if valid_url?
      input_html_options.delete(:remove_path)
      build_remove_button(out, object.send(attribute_name))
    end

    out
  end

  def build_preview(out)
    # check if there's an uploaded file (eg: edit mode or form not saved)
    # append preview image to output
    out << image_preview if object.send("#{attribute_name}?")

    # allow multiple submissions without losing the tmp version
    out << @builder.hidden_field("#{attribute_name}_cache")
  end

  def build_buttons(out)
    # It's not possible to style the "Choose file" button that's standard for a file input
    # So instead, here's a label that will cover the top of the browser button
    # This can be CSSed into something prettier
    out << @builder.file_field(attribute_name, input_html_options)
    out << @builder.label(attribute_name, t("choose"), class: "choose-file")
  end

  def valid_url?
    url = object.send(attribute_name.to_s)&.url

    # cached files on tmp are not reliable behind a load balancer
    url && !url.to_s.starts_with?("/uploads/tmp/")
  end

  def build_remove_button(out, _image)
    out << template.label_tag("#{object.model_name.param_key}_remove_#{attribute_name}",
                              "",
                              class: "btn remove-btn fa fa-trash")
    out << @builder.check_box("remove_#{attribute_name}",
                              label: false, class: "hidden remove-image")
  end

  def image_preview
    version = input_html_options.delete(:preview_version)
    url = object.send(attribute_name).tap { |o| break o.send(version) if version }.send("url")

    template.image_tag(url, class: "image-preview") if url.present?
  end
end
