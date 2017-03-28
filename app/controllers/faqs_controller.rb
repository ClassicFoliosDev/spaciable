# frozen_string_literal: true
class FaqsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :division
  load_and_authorize_resource :developer
  load_resource :faq, through: [:development, :division, :developer], shallow: true

  before_action :set_parent

  def index
    authorize! :index, Faq

    @faqs = paginate(sort(@faqs, default: :question))
  end

  def new
    authorize! :new, @faq
  end

  def create
    authorize! :create, @faq

    if @faq.save
      redirect_to [@parent, :faqs], notice: t("controller.success.create", name: @faq)
    else
      render :new
    end
  end

  def update
    authorize! :update, @faq

    if @faq.update(faq_params)
      redirect_to [@parent, :faqs], notice: t("controller.success.update", name: @faq)
    else
      render :edit
    end
  end

  def show
    authorize! :show, @faq
  end

  def edit
    authorize! :edit, @faq
  end

  def destroy
    authorize! :destroy, @faq

    @faq.destroy
    notice = t("controller.success.destroy", name: @faq)
    redirect_to [@parent, :faqs], notice: notice
  end

  private

  def faq_params
    params.require(:faq).permit(
      :question,
      :answer,
      :category,
      :division_id
    )
  end

  def set_parent
    @parent = @development || @division || @developer || @faq&.faqable
    @faq&.faqable = @parent
  end
end
