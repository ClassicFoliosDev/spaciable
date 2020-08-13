# frozen_string_literal: true

class SyncFaqsController < ApplicationController
  load_and_authorize_resource :sync_faq
  load_and_authorize_resource :default_faq

  def create
    p_klass = sync_faq_params[:parent_type].classify.constantize
    parent = p_klass.find_by(id: sync_faq_params[:parent_id])

    sync_faq_params[:faqs].reject!(&:empty?).each do |f|
      SyncFaq.sync_parent_faqs(f, parent)
    end

    faq_type = FaqType.find(active_tab)
    puts "#################### #{faq_type}"
    redirect_to [parent, :faqs, active_tab: faq_type.id]
  end

  private

  def active_tab
    params.permit(:active_tab)[:active_tab]
  end

  def sync_faq_params
    params.require(:sync_faq).permit(:parent_id, :parent_type, faqs: [])
  end
end
