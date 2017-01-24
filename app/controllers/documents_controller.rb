# frozen_string_literal: true
class DocumentsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :developer
  load_and_authorize_resource :document, through: :developer, shallow: true

  def index
    @documents = paginate(sort(@documents, default: :title))
  end

  def new
    @parent = Developer.find(params[:developer_id])
  end

  def edit
  end

  def show
  end

  def create
    @document.set_original_filename
    if @document.save
      redirect_to developer_path(@document.developer, active_tab: "documents"),
                  notice: t("controller.success.create", name: @document.title)
    else
      @parent = Developer.find(params[:developer_id])
      render :new
    end
  end

  def update
    if @document.update(document_params)
      redirect_to documents_url, notice: t("controller.success.update", name: @document.title)
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_url, notice: t("controller.success.destroy", name: @document.title)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_params
    params.require(:document).permit(:title, :file)
  end
end
