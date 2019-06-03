# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

module Homeowners
  class SnagsController < Homeowners::BaseController
    skip_authorization_check
    before_action :set_snag, only: %i[show edit update destroy]

    def index
      @snags = Snag.where(plot_id: @plot.id).order(updated_at: :desc)
    end

    def show
      @snag_attachments = @snag.snag_attachments
      @snag_comment = SnagComment.new
      @snag_comments = @snag.snag_comments
    end

    def new
      @snag = Snag.new
      @snag_attachment = @snag.snag_attachments.build
    end

    def edit; end

    def create
      @snag = Snag.new(snag_params)
      if @snag.save
        @snag.update_attributes(plot_id: @plot.id)
        if params[:snag_attachments].present?
          params[:snag_attachments]["image"].each do |i|
            @snag_attachment = @snag.snag_attachments.create!(image: i, snag_id: @snag.id)
          end
        end
        increment_snag_counts
        check_resolved_notification(@plot)
        notify_and_redirect("create")
      else
        render :new
      end
    end

    def update
      if @snag.update(snag_params)
        if @snag.status == "rejected" || @snag.status == "approved"
          decrement_unresolved_snag_counts if @snag.status == "approved"
          notify_response
          @snag.update_attributes(status: "unresolved") if @snag.status == "rejected"
        else
          upload_attachments if params[:snag_attachments].present?
          notify_and_redirect("update")
        end
      else
        render :edit
      end
    end

    def destroy
      notify_delete
      decrement_snag_counts
      @snag.destroy
    end

    private

    def check_resolved_notification(plot)
      plot_id = plot.id
      @plot_number = plot.number
      @address = [plot.prefix, plot.postal_number,
                  plot.building_name, plot.road_name].compact.join(" ")
      notification = Notification
                     .where(send_to_id: plot_id)
                     .where(message:
                            I18n.t(".resident_snag_mailer.all_snags_resolved_email.resolved",
                                   address: @address, plot: @plot_number))
      notification.destroy_all if notification.exists?
    end

    def upload_attachments
      params[:snag_attachments]["image"].each do |i|
        @snag_attachment = @snag.snag_attachments.create!(image: i, snag_id: @snag.id)
      end
    end

    def set_snag
      @snag = Snag.find(params[:id])
    end

    def notify_and_redirect(status)
      SnagMailer.snag_to_admins(@snag, status).deliver
      redirect_to snag_path(id: @snag.id)
    end

    def notify_delete
      SnagMailer.snag_to_admins(@snag, "delete").deliver
      redirect_to snags_path, notice: t(".delete_success")
    end

    def notify_response
      notify_resolved_status if (@snag.status == "approved") && @plot.snags_fully_resolved
      SnagMailer.response_resolved_status(@snag, @snag.status).deliver
      redirect_to snag_path(id: @snag.id), notice: t(".notify_status", status: @snag.status)
    end

    def notify_resolved_status
      ResidentSnagService.resolved(@plot)
    end

    def increment_snag_counts
      increment_total_snag_counts
      increment_unresolved_snag_counts
    end

    def decrement_snag_counts
      decrement_total_snag_counts
      decrement_unresolved_snag_counts
    end

    def plot_and_phase
      @plot = @snag.plot
      @phase = @plot.phase
    end

    def increment_total_snag_counts
      plot_and_phase
      @plot.increment(:total_snags)
      @phase.increment(:total_snags)
      save_counters
    end

    def decrement_total_snag_counts
      plot_and_phase
      @plot.decrement(:total_snags)
      @phase.decrement(:total_snags)
      save_counters
    end

    def increment_unresolved_snag_counts
      plot_and_phase
      @plot.increment(:unresolved_snags)
      @phase.increment(:unresolved_snags)
      save_counters
    end

    def decrement_unresolved_snag_counts
      plot_and_phase
      @plot.decrement(:unresolved_snags)
      @phase.decrement(:unresolved_snags)
      save_counters
    end

    def save_counters
      @plot.save!
      @phase.save!
    end

    def snag_params
      params.require(:snag).permit(:title, :description, :status)
    end
  end
end
# rubocop:enable Metrics/ClassLength
