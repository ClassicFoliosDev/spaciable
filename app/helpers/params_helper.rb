# frozen_string_literal: true

module ParamsHelper

  def safe_params(action, parent, type, plot, params)
    [
      action,
      parent.blank? ? nil : parent.to_sym, 
      type.name.underscore.to_sym,
      plot: plot,
      params: params_to_h(params)
    ]
  end

  private 

  def params_to_h(params)
    return params if params.is_a? Hash
    params.permit!.to_hash
  end
end
