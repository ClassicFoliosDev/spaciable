# frozen_string_literal: true

module Admin
  class DefaultFaqsController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :default_faq, except: %i[index]

    def index
      authorize! :index, DefaultFaq

      @faq_type = (FaqType.find(active_tab) if index_params[:active_tab]) ||
                  FaqType.default(Country.find(index_params[:country]))
      @faqs = paginate(sort(DefaultFaq.of_type(@faq_type)))

      # FAQ relies on active_tab and country query parameters.  The
      # sort and paginate callbacks need to supply these in order for
      # the current page selections to be maintained.
      @qp = index_params.to_h
    end

    def new
      authorize! :new, @default_faq
      @faq_type = FaqType.find(active_tab)
    end

    def create
      authorize! :create, @default_faq
      @faq_type = FaqType.find(faq_type_param)

      if @default_faq.save
        notice = t("controller.success.create", name: @default_faq)
        redirect_to [:admin_settings, :default_faqs, active_tab: @default_faq.faq_type.id],
                    notice: notice
      else
        render :new
      end
    end

    def show; end

    def edit
      @faq_type = @default_faq.faq_type
    end

    def update
      authorize! :update, @default_faq

      if @default_faq.update(default_faq_params)
        notice = t("controller.success.update", name: @default_faq)
        redirect_to [:admin_settings, :default_faqs, active_tab: @default_faq.faq_type.id],
                    notice: notice
      else
        @faq_type = FaqType.find(faq_type_param)
        render :edit
      end
    end

    def destroy
      authorize! :destroy, @default_faq

      type = @default_faq.faq_type
      @default_faq.destroy
      notice = t("controller.success.destroy", name: @default_faq)
      redirect_to [:admin_settings, :default_faqs, active_tab: type.id], notice: notice
    end

    private

    def index_params
      params.permit(:country, :active_tab)
    end

    def active_tab
      params.permit(:active_tab)[:active_tab]
    end

    def default_faq_params
      params.require(:default_faq).permit(
        :question,
        :answer,
        :faq_type_id,
        :faq_category_id,
        :category,
        :country_id
      )
    end

    def faq_type_param
      params.require(:default_faq).permit(:faq_type_id)[:faq_type_id]
    end
  end
end
