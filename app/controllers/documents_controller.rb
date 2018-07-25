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
    %i[developer
       division
       development
       phase
       unit_type
       plot], shallow: true

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

    if @document.save
      @document.update_attributes(user_id: current_user.id)
      @document.set_original_filename
      notify_and_redirect
    else
      render :new
    end
  end

  def update
    authorize! :update, @document

    if @document.update(document_params)
      @document.set_original_filename
      respond_to do |format|
        build_response(format)
      end
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @document
    @document.destroy
    notice = t("controller.success.destroy", name: @document.title)
    redirect_to target, notice: notice
  end

  private

  def build_response(format)
    format.html do
      notice = t("controller.success.update", name: @document.title)
      if document_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@document, current_user,
                                                   t("notify.updated"), @document.parent)
      end
      redirect_to target, notice: notice
    end

    format.json do
      render json: @document.to_json, status: :ok
    end
  end

  def notify_and_redirect
    notice = t("controller.success.create", name: @document.title)

    if document_params[:notify].to_i.positive?
      notice << ResidentChangeNotifyService.call(@document, current_user,
                                                 t("notify.added"), @document.parent)
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
