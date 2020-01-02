# frozen_string_literal: true

class VideosController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :development
  load_and_authorize_resource :video, through: [:development], shallow: true
  before_action :set_parent

  def index
    @videos = paginate(sort(@videos, default: :title))
  end

  def new
    (redirect_to root_url unless current_user.cf_admin?) if @parent.expired?
  end

  def edit
    (redirect_to video_path unless current_user.cf_admin?) if @parent.expired?
  end

  def show; end

  def create
    if @video.save
      notice = t("controller.success.create", name: @video.title)
      if video_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@video, current_user,
                                                   t("notify.added"), @parent)
      end
      redirect_to [@parent, :videos], notice: notice
    else
      render :new
    end
  end

  def update
    if @video.update(video_params)
      notice = t("controller.success.update", name: @video.title)
      if video_params[:notify].to_i.positive?
        notice << ResidentChangeNotifyService.call(@video, current_user,
                                                   t("notify.updated"), @parent)
      end
      redirect_to [@parent, :videos], notice: notice
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    notice = t(
      "controller.success.destroy",
      name: @video.title
    )
    redirect_to [@parent, :videos], notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def video_params
    params.require(:video).permit(
      :title,
      :link,
      :notify
    )
  end

  def set_parent
    @parent = @development || @video&.videoable
    @video&.videoable = @parent
  end
end
