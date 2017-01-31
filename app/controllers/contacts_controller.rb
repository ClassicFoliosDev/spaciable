# frozen_string_literal: true
class ContactsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :contact

  def index
    @contacts = paginate(sort(@contacts, default: :last_name))
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    if @contact.save
      redirect_to contacts_path, notice: t("controller.success.create", name: @contact)
    else
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to contact_path, notice: t("controller.success.update", name: @contact)
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    notice = t(
      "controller.success.destroy",
      name: @contact
    )
    redirect_to contacts_url, notice: notice
  end

  def remove_contact
    # TODO: Requires a parent, which doesn't exist until HOOZ-51
    redirect_to contacts_url
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(
      :title,
      :first_name,
      :last_name,
      :position,
      :email,
      :phone,
      :category,
      :mobile,
      :picture,
      :remove_picture,
      :picture_cache
    )
  end
end
