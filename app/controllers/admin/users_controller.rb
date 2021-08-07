# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :user, except: %i[export_csv]
    skip_authorization_check only: %i[export_csv]

    def index
      @usearch = UserSearch.new(search_params)
      @users = User.full_details(params, current_ability, @usearch)
      @per_page = @users.limit_value
    end

    def new
      @user.receive_choice_emails = true
      @user.build
    end

    def create
      email = user_params[:email].downcase.strip
      if (@restore_user = User.only_deleted.find_by(email: email))
        @restore_user.restore!
        @user = @restore_user
        # remove blank params so the user can be re-added by email only
        params = user_params.delete_if { |_k, v| v.blank? }
        UpdateUserService.call(@user, params)
        validate_user
      elsif @user.create_without_password
        user_success
      else
        render :new
      end
    end

    def show; end

    def edit
      @user.assign_permissionable_ids
      @user.build
    end

    def update
      if UpdateUserService.call(@user, user_params)
        if user_params[:password] && user_params[:password].present?
          redirect_to new_user_session_url, notice: t(".success_password", user_name: @user.to_s)
        else
          redirect_to %i[admin users], notice: t(".success", user_name: @user.to_s)
        end
        if user_params[:role] == "cf_admin"
          @user.update_attributes(permission_level_type: nil, permission_level_id: nil)
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

    def export_csv
      ExportAdminsJob.perform_later(current_user, search_params.to_h)
      render json: { status: 200 }
    end

    def user_success
      # rubocop:disable SkipsModelValidations
      @user.update_attribute(:snag_notifications, false) if @user.site_admin? || @user.cf_admin?
      # rubocop:enable SkipsModelValidations
      @user.invite!(current_user)
      notice = t(".success", user_email: @user.to_s)
      redirect_to %i[admin users], notice: notice
    end

    def resend_invitation
      user = User.find(params[:user])
      invitee = User.find(params[:invitee])

      user.invite!(invitee, bcc: ENV["BCC_MAIL"])
    end

    private

    def validate_user
      # check that the restored user has a valid permission level
      if !@user.cf_admin? && (@user.permission_level_id.nil? || !@user.permission_level.valid?)
        @user.destroy
        render :new
      else
        user_success
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email, :role, :first_name, :last_name,
        :developer_id, :division_id,
        :development_id, :permission_level_id,
        :permission_level_type, :password, :password_confirmation,
        :current_password, :picture, :picture_cache,
        :job_title, :receive_release_emails, :snag_notifications,
        :receive_choice_emails, :branch_administrator, :cas,
        :receive_invitation_emails, :receive_faq_emails,
        cc_emails_attributes: %i[user_id email_type email_list id _destroy],
        grants_attributes: %i[id role permission_level_type permission_level_id _destroy]
      )
    end

    def search_params
      return unless params.include?("user_search")

      params.require("user_search").permit(:developer_id, :division_id, :development_id, :role)
    end
  end
end
