# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :user

    def index
      @users = @users.includes(:permission_level)
      @users = sort(@users, default: :email)
      @users = paginate(@users)
    end

    def new; end

    def create
      if (@restore_user = User.only_deleted.find_by(email: user_params[:email]))
        @restore_user.restore!
        @user = @restore_user
        UpdateUserService.call(@user, user_params)
        user_success
      elsif @user.create_without_password
        user_success
      else
        render :new
      end
    end

    def show; end

    def edit
      @user.assign_permissionable_ids
    end

    def update
      if UpdateUserService.call(@user, user_params)
        if user_params[:password]
          redirect_to new_user_session_url, notice: t(".success_password", user_name: @user.to_s)
        else
          redirect_to %i[admin users], notice: t(".success", user_name: @user.to_s)
        end
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      notice = t(".archive.success", user_email: @user.email)
      redirect_to admin_users_path, notice: notice
    end

    def user_success
      @user.invite!(current_user)
      notice = t(".success", user_email: @user.to_s)
      redirect_to %i[admin users], notice: notice
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email, :role,
        :first_name, :last_name,
        :developer_id,
        :division_id,
        :development_id,
        :permission_level_id,
        :permission_level_type,
        :password, :password_confirmation,
        :current_password,
        :picture, :picture_cache,
        :job_title
      )
    end
  end
end
