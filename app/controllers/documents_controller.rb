# frozen_string_literal: true
class DocumentsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :unit_type
  load_and_authorize_resource :plot
  load_and_authorize_resource :document, through:
    [:developer,
     :division,
     :development,
     :phase,
     :unit_type,
     :plot], shallow: true

  before_action :set_parent

  def new
  end

  def edit
  end

  def show
  end

  def create
    @document.set_original_filename
    @document.documentable = @parent

    if @document.save
      notice = t("controller.success.create", name: @document.title)
      redirect_to redirect_path, notice: notice
    else
      @parent = Developer.find(params[:developer_id])
      render :new
    end
  end

  def update
    if @document.update(document_params)
      respond_to do |format|
        format.html do
          redirect_to redirect_path, notice: t("controller.success.update", name: @document.title)
        end
        format.json do
          render json: @document.to_json, status: :ok
        end
      end
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to redirect_path, notice: t("controller.success.destroy", name: @document.title)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :file, :category, :documentable_id)
  end

  def set_parent
    @parent = @plot || @phase || @development || @division || @developer || @document&.documentable
  end

  def redirect_path
    if @parent&.model_name.element.to_sym == :plot ||
       @parent&.model_name.element.to_sym == :developer
      [@parent, active_tab: "documents"]
    else
      [@parent&.parent, @parent, active_tab: "documents"].compact
    end
  end
end
