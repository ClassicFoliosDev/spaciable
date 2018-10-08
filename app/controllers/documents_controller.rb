# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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
    %i[developer division development phase unit_type plot], shallow: true

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

    document_params[:files]&.each do |file|
      create_document(file)
    end

    process_error && return if @document.errors.any?
    notify_and_redirect(document_params[:files]&.count)
  end

  def update
    authorize! :update, @document

    if @document.update(document_params)
      @document.set_original_filename
      @document.save
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
    redirect_to target, notice: t("controller.success.destroy", name: @document.title)
  end

  private

  def process_error
    render :new, alert: I18n.t("activerecord.errors.messages.not_save_documents",
                               message: @document.errors.full_messages.first)
  end

  def create_document(file)
    document = Document.new(file: file)
    document.set_original_filename

    document.save
    @document = document unless document.valid?

    document.update_attributes(user_id: current_user.id, documentable: @parent,
                               category: document_params[:category])
  end

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

  def notify_and_redirect(count)
    notice = t("controller.success.create", name: I18n.t("controller.success.count", count: count))

    if document_params[:notify].to_i.positive?
      notice << ResidentChangeNotifyService.call(@document, current_user,
                                                 t("notify.added"), @document.parent)
    end

    redirect_to target, notice: notice
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :category, :documentable_id, :notify, files: [])
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
# rubocop:enable Metrics/ClassLength
