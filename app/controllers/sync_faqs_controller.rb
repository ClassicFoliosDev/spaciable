# frozen_string_literal: true

class SyncFaqsController < ApplicationController
  load_and_authorize_resource :sync_faq
  load_and_authorize_resource :default_faq

  def create
    puts "################################## #{sync_faq_params[:faqs]}"
    sync_faq_params[:faqs].each do |f|
      faq = DefaultFaq.find_by(id: f)
      puts "#################### #{faq}"
    end
  end

  private

  def sync_faq_params
    params.require(:sync_faq).permit(:parent, :faqs => [])
  end
end
