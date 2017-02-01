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
      notice = t("controller.success.create", name: @contact)
      redirect_to [@parent, :contacts], notice: notice
    else
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      notice = t("controller.success.update", name: @contact)
      redirect_to [@parent, :contacts], notice: notice
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
    redirect_to [@parent, :contacts], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(
      :title, :first_name, :last_name, :position,
      :email, :phone, :category, :mobile, :picture,
      :remove_picture, :picture_cache, :contactable_id,
      :contactable_type, :organisation
    )
  end

  def set_parent
    @parent = @contact&.contactable || @development || @division || @developer
  end
end
