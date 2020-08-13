# frozen_string_literal: true

class SyncFaqsController < ApplicationController
  load_and_authorize_resource :default_faq

  load_and_authorize_resource :development
  load_and_authorize_resource :division
  load_and_authorize_resource :developer

  before_action :set_parent

  def index
    @faq_type = FaqType.find(active_tab)
    @faqs = DefaultFaq.where(faq_type_id: @faq_type)
    # group by category
    @grouped_faqs = @faqs.group_by { |faq| FaqCategory.find(faq[:faq_category_id]).name }

    @parent_faqs = Faq.where(faqable: @parent)
  end

  def create
    @faq_type = sync_faq_params[:faq_type]

    sync_faq_params[:faqs].reject!(&:empty?).each do |f|
      SyncFaq.sync_parent_faqs(f, @parent)
    end

    redirect_to [@parent, :faqs, active_tab: @faq_type]
  end

  private

  def active_tab
    params.permit(:active_tab)[:active_tab]
  end

  def sync_faq_params
    params.require(:sync_faq).permit(:faq_type, faqs: [])
  end

  def set_parent
    @parent = @development || @division || @developer
  end
end
