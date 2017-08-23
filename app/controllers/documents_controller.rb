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
  load_resource :document, through:
    [:developer,
     :division,
     :development,
     :phase,
     :unit_type,
     :plot], shallow: true

  before_action :set_parent

  def index
    authorize! :index, Document
    @documents = paginate(sort(@documents, default: :title))
  end

  def new
    authorize! :new, @document
    @redirect_path = url_for(target)
  end

  def edit
    authorize! :edit, @document
    @redirect_path = url_for(target)
  end

  def show
    authorize! :show, @document
    @redirect_path = url_for(target)
  end

  def create
    authorize! :create, @document

    @document.set_original_filename

    if @document.save
      notice = t("controller.success.create", name: @document.title)
      if document_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService
                  .call(@document.parent, current_user, Document.model_name.human.pluralize)
      end

      redirect_to target, notice: notice
    else
      render :new
    end
  end

  def update
    authorize! :update, @document

    if @document.update(document_params)
      respond_to do |format|
        format.html do
          process_html_format
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
    authorize! :destroy, @document

    @document.destroy
    redirect_to target, notice: t("controller.success.destroy", name: @document.title)
  end

  private

  def process_html_format
    notice = t("controller.success.update", name: @document.title)
    if document_params[:notify].to_i.positive?
      notice << ResidentChangeNotifyService
                .call(@document.parent, current_user, Document.model_name.human.pluralize)
    end
    redirect_to target, notice: notice
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :file, :category, :documentable_id, :notify)
  end

  def set_parent
    @parent = @plot || @phase || @development || @division || @developer || @document&.documentable

    @document&.documentable = @parent
  end

  def target
    if @parent&.model_name&.element&.to_sym == :plot ||
       @parent&.model_name&.element&.to_sym == :developer
      [@parent, active_tab: "documents"]
    else
      [@parent&.parent, @parent, active_tab: "documents"].compact
    end
  end
end
