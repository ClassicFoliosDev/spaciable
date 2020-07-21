# frozen_string_literal: true

class UserSearch < User
  attr_accessor :role

  scope :residents,
        lambda { |search|
          if search.populated?
            Resident.joins(plot_residencies: :plot)
                    .where(plots: search.res_criteria)
                    .where(plot_residencies: search.residency)
          else
            Resident.joins(:plot_residencies)
                    .where(plot_residencies: search.residency)
          end
        }

  def populated?
    developer_id.present? || division_id.present? || development_id.present?
  end

  def res_criteria
    if development_id.present?
      { development_id: development_id }
    elsif division_id.present?
      { division_id: division_id }
    else
      { developer_id: developer_id }
    end
  end

  def admin_criteria
    return if @role.nil?

    criteria = " AND users.role IN (#{admin_roles.join(',')})"

    return criteria unless populated?

    criteria + if development_id.present?
                 " AND developments.id = #{development_id}"
               elsif division_id.present?
                 " AND divisions.id = #{division_id}"
               else
                 " AND developers.id = #{developer_id}"
               end
  end

  def residency
    if @role.present?
      { role: PlotResidency.roles[@role] }
    else
      { role: (PlotResidency.roles.map { |v, _| v }) }
    end
  end

  def admin_roles
    if @role.present?
      [User.roles[@role]]
    else
      User.roles.map { |_, v| v }
    end
  end

  def query_params
    params = { user_search: {} }
    params[:user_search][:developer_id] = developer_id if developer_id.present?
    params[:user_search][:division_id] = division_id if division_id.present?
    params[:user_search][:development_id] = development_id if development_id.present?
    params[:user_search][:role] = @role if @role.present?
    params
  end
end
