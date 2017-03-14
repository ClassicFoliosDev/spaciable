# frozen_string_literal: true
class UsersController < ApplicationController
  load_and_authorize_resource

  def index; end

  def new; end

  def edit; end

  def show; end

  def create
    if @user.save
      redirect_to @user, notice: t("controller.success.create", name: @user.email)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t("controller.success.update", name: @user.email)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: t("controller.success.destroy", name: @user.email)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :role,
      :developer_id,
      :division_id
    )
  end
end
