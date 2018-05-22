# frozen_string_literal: true

module DeleteHelper
  def data_to_delete(resource, path: nil)
    {
      id: resource.id,
      url: path || url_for(resource),
      name: resource.to_s,
      cancel: t("destroy.cancel"),
      title: t("destroy.confirm_title"),
      text: confirm_text(resource),
      cta: t("destroy.destroy"),
      action: :delete
    }
  end

  def confirm_text(resource)
    unless resource.is_a? Resident
      return t("destroy.confirm_text", type: resource.class.model_name.human)
    end

    return t("destroy.confirm_resident") if resource.plots.count > 1
    t("destroy.confirm_final_resident")
  end
end
