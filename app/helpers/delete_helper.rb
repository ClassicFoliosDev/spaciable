# frozen_string_literal: true
module DeleteHelper
  def data_to_delete(resource)
    {
      id: resource.id,
      url: url_for(resource),
      name: resource.to_s,
      cancel: t("views.cancel"),
      title: t("views.confirm_title"),
      text: t("views.confirm_text", type: resource.class.model_name.human),
      cta: t("views.destroy"),
      action: :delete
    }
  end
end
