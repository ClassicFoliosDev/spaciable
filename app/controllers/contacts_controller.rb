# frozen_string_literal: true
class ContactsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :development
  load_and_authorize_resource :contact,
                              through: [:developer, :division, :development],
                              shallow: true

  before_action :set_parent

  def index
    authorize! :index, Contact

    @contacts = paginate(sort(@contacts, default: :last_name))
    @contact = @parent.contacts.build
  end

  def new
    authorize! :new, @contact
  end

  def edit
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
        result = ResidentChangeNotifyService.call(@contact.parent,
                                                  current_user,
                                                  Contact.model_name.human.pluralize)
        notice << t("resident_notification_mailer.notify.update_sent", count: result)
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
        result = ResidentChangeNotifyService.call(@contact.parent,
                                                  current_user,
                                                  Contact.model_name.human.pluralize)
        notice << t("resident_notification_mailer.notify.update_sent", count: result)
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
    @parent = @development || @division || @developer || @contact&.contactable
    @contact&.contactable = @parent
  end
end
