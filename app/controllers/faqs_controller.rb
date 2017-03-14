# frozen_string_literal: true
class FaqsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :division
  load_and_authorize_resource :developer
  load_and_authorize_resource :faq, through: [:development, :division, :developer], shallow: true

  before_action :set_parent

  def index
    @faqs = paginate(sort(@faqs, default: :question))
    @faq = @parent.faqs.build
  end

  def new; end

  def create
    @faq.faqable = @parent

    if @faq.save
      redirect_to [@parent, :faqs], notice: t(".success", title: @faq)
    else
      render :new
    end
  end

  def update
    if @faq.update(faq_params)
      redirect_to [@parent, :faqs], notice: t(".success", title: @faq)
    else
      render :edit
    end
  end

  def show; end

  def edit; end

  def destroy
    @faq.destroy
    notice = t(".success", title: @faq)
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
  end
end
