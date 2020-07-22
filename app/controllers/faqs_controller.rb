# frozen_string_literal: true

class FaqsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :division
  load_and_authorize_resource :developer
  load_resource :faq, through: %i[development division developer], shallow: true

  before_action :set_parent

  def index
    authorize! :index, Faq
    @faq_type = FaqType.find(active_tab)
    @faqs = paginate(sort(@faqs.where(faq_type: @faq_type), default: :question))
  end

  def new
    if @parent.expired?
      redirect_to root_url unless current_user.cf_admin?
    end
    authorize! :new, @faq
    @faq_type = FaqType.find(active_tab)
  end

  def create
    authorize! :create, @faq
    @faq_type = FaqType.find(faq_type_param)

    if @faq.save
      notice = t("controller.success.create", name: @faq)
      if faq_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@faq, current_user,
                                                   t("notify.added"), @faq.parent)
      end
      redirect_to [@parent, :faqs, active_tab: @faq_type.id], notice: notice
    else
      render :new
    end
  end

  def update
    authorize! :update, @faq

    if @faq.update(faq_params)
      notice = t("controller.success.update", name: @faq)
      if faq_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@faq, current_user,
                                                   t("notify.updated"), @faq.parent)
      end
      redirect_to [@parent, :faqs, active_tab: @faq.faq_type.id], notice: notice
    else
      @faq_type = FaqType.find(faq_type_param)
      render :edit
    end
  end

  def show
    authorize! :show, @faq
  end

  def edit
    if @parent.expired?
      redirect_to faq_path unless current_user.cf_admin?
    end
    authorize! :edit, @faq
    @faq_type = @faq.faq_type
  end

  def destroy
    authorize! :destroy, @faq

    type = @faq.faq_type
    @faq.destroy
    notice = t("controller.success.destroy", name: @faq)
    redirect_to [@parent, :faqs, active_tab: type.id], notice: notice
  end

  def sync_faqs
    faq_type = FaqType.find(active_tab)
    @faqs = DefaultFaq.where(faq_type_id: faq_type)
  end

  private

  def faq_params
    params.require(:faq).permit(
      :question,
      :answer,
      :faq_type_id,
      :faq_category_id,
      :division_id,
      :notify
    )
  end

  def faq_type_param
    params.require(:faq).permit(:faq_type_id)[:faq_type_id]
  end

  def active_tab
    params.permit(:active_tab)[:active_tab]
  end

  def set_parent
    @parent = @development || @division || @developer || @faq&.faqable
    @faq&.faqable = @parent
  end
end
