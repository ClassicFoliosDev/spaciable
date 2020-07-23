# frozen_string_literal: true

class SyncFaqsController < ApplicationController
  load_and_authorize_resource :sync_faq

  def create
    puts "################################## #{params[:faqs]}"
  end

  private

  def sync_faq_params
    params.require(:sync_faq).permit(:faqs => [])
  end
end
