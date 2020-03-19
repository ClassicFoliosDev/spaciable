# frozen_string_literal: true

module DeleteHelper
  def data_to_delete(resource, path: nil, text: nil)
    {
      id: resource.id,
      url: path || url_for(resource),
      name: text ? "" : resource.to_s,
      cancel: t("destroy.cancel"),
      title: t("destroy.confirm_title"),
      text: text || confirm_text(resource),
      cta: t("destroy.destroy"),
      action: :delete
    }
  end

  def permissable_data_to_delete(resource, path: nil)
    {
      cancel: t("edit.cancel"),
      cta: t("admin_permissable_destroy.confirm"),
      title: t("admin_permissable_destroy.warning"),
      user: current_user.id,
      path: path || url_for(resource),
      name: resource.to_s,
      plots: resource.plots.count
    }
  end

  # rubocop:disable OutputSafety
  def confirm_text(resource)
    unless resource.is_a? Resident
      return t("destroy.confirm_text", type: resource.class.model_name.human)
    end

    return t("destroy.confirm_resident_admin").html_safe if resource.plots.count > 1
    t("destroy.confirm_final_resident_admin").html_safe
  end
  # rubocop:enable OutputSafety
end
