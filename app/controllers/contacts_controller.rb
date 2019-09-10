# frozen_string_literal: true

class ContactsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :development
  load_and_authorize_resource :phase
  load_and_authorize_resource :contact,
                              through: %i[developer division development phase],
                              shallow: true

  before_action :set_parent

  def index
    authorize! :index, Contact

    @resident_count = @parent&.plot_residencies&.size
    @subscribed_resident_count = @parent&.residents&.where(cf_email_updates: true)&.size

    @active_plots_count = @phase&.active_plots_count
    @completed_plots_count = @phase&.completed_plots_count
    @expired_plots_count = @phase&.expired_plots_count
    @activated_resident_count = @phase&.activated_resident_count

    @contacts = paginate(sort(@parent.contacts, default: :last_name))
    @contact = @parent.contacts.build
  end

  def new
    if @parent.expired?
      redirect_to root_url unless current_user.cf_admin?
    end
    authorize! :new, @contact
  end

  def edit
    if @contact.expired?
      redirect_to contact_path unless current_user.cf_admin?
    end
    authorize! :edit, @contact
  end

  def show
    authorize! :show, @contact
  end

  def create
    authorize! :create, @contact

    if @contact.save
      notice = t("controller.success.create", name: @contact)
      if contact_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@contact, current_user,
                                                   t("notify.added"), @contact.parent)
      end
      redirect_to [@parent, :contacts], notice: notice
    else
      render :new
    end
  end

  def update
    authorize! :update, @contact

    if @contact.update(contact_params)
      notice = t("controller.success.update", name: @contact)
      if contact_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@contact, current_user,
                                                   t("notify.updated"), @contact.parent)
      end
      redirect_to [@parent, :contacts], notice: notice
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @contact

    @contact.destroy
    notice = t(
      "controller.success.destroy",
      name: @contact
    )
    redirect_to [@parent, :contacts], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(
      :title, :first_name, :last_name, :position,
      :email, :phone, :category, :mobile, :picture,
      :remove_picture, :picture_cache, :contactable_id,
      :contactable_type, :organisation, :notify
    )
  end

  def set_parent
    @parent = @phase || @development || @division || @developer || @contact&.contactable
    @contact&.contactable = @parent
  end
end
