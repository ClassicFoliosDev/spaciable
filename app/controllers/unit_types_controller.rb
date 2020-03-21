# frozen_string_literal: true

class UnitTypesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development
  load_and_authorize_resource :unit_type, through: :development, except: [:clone]

  def index
    @unit_types = paginate(sort(@unit_types, default: :name))
  end

  def new; end

  def edit; end

  def show
    # If no tab has been specified and CAS is active
    if params[:active_tab].nil? &&
       (current_user.cf_admin? || (current_user.cas && @development.cas))
      redirect_to [@unit_type, :rooms]
    end

    @active_tab = params[:active_tab] || "documents"

    case @active_tab
    when "documents"
      documents = @unit_type.documents
      @collection = paginate(sort(documents, default: :title))
    when "logs"
      logs = Log.logs(@unit_type)
      @collection = paginate(sort(logs, default: { created_at: :desc }))
    end
  end

  def create
    if @unit_type.save
      notice = t(
        "controller.success.create",
        name: @unit_type.name
      )
      redirect_to [@development.parent, @development, active_tab: :unit_types], notice: notice
    else
      render :new
    end
  end

  def update
    if @unit_type.update(unit_type_params)
      notice = t(
        "controller.success.update",
        name: @unit_type.name
      )
      redirect_to [@development.parent, @development, active_tab: :unit_types], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @unit_type.destroy
    notice = t("controller.success.destroy", name: @unit_type.name)
    redirect_to [@development.parent, @development, active_tab: :unit_types], notice: notice
  end

  def clone
    @unit_type = UnitType.find(params[:id])
    @development = @unit_type.parent

    new_unit_type = @unit_type.amoeba_dup
    new_unit_type.name = CloneNameService.call(@unit_type.name)
    if new_unit_type.save
      notice = t("controller.success.create", name: new_unit_type.name)
    else
      alert = t("activerecord.errors.messages.clone_not_possible", name: @unit_type.name)
      alert << AppliancesFinishesErrorsService.unit_type_errors(new_unit_type)
    end

    redirect_to [@development.parent, @development, active_tab: :unit_types],
                alert: alert, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def unit_type_params
    params.require(:unit_type).permit(:name, :picture, :external_link, :restricted, phase_ids: [])
  end
end
