class WalkInsController < ApplicationController

  before_action :set_walkin,only: [:edit,:update,:destroy,:change_status,:mark_checkin,:send_message,:stop_sequence]

  def index
    @walk_ins = WalkIn.by_restaurant(my_restaurant).where('booking_date > ?', '2020-07-23').created.order(created_at: :asc)
    @reservations = Reservation.by_restaurant(my_restaurant).where('booking_date > ?', '2020-07-23').created.order(:booking_date).order(:booking_time)
    @walk_in = WalkIn.new(size: 2,restaurant_id: my_restaurant.id)
  end

  def new
    @walk_in = WalkIn.new(size: 2,restaurant_id: my_restaurant.id)
  end

  def create
    @walk_in = WalkIn.new(walk_in_params)
    @walk_in.booking_date = Date.today.in_time_zone(current_user.time_zone)
    @walk_in.save
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def edit
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def update
    @walk_in.update(walk_in_params)
    @walk_in.set_customer
    ActionCable.server.broadcast 'bookings',
        message: "#{@walk_in.id} is updated",
        user: current_user.email
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def change_status
    @walk_in.send("#{params[:status]}!")
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def mark_checkin
    @walk_in.set_checkin(true)
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def destroy
    @walk_in.cancelled!
    @walk_in.destroy
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def send_message
    template = @walk_in.restaurant.message_templates.first
    if template.nil?
      redirect_to messages_path,alert: "You don't have any message template. Please create message template first."
      return
    elsif !template.approved
      redirect_to messages_path,alert: "Your message template is not approved yet by Admin."
      return
    end
    # update sequence in progress for template
    @walk_in.update({sequence_in_progress: true, message_started_at: Time.zone.now})
    response = @walk_in.send_message(template)
    if response[:error]
      redirect_to walk_ins_path,alert: response[:message]
    else
      redirect_to walk_ins_path,notice: "Message is sent successfully to `#{@walk_in.phone}`."
    end
  end

  def stop_sequence
    @walk_in.update(sequence_in_progress: false)
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  private

    def walk_in_params
      params.require(:walk_in).permit(:booking_date,:booking_time,:wait_in_minutes,:size,:phone,:party_name,:notes,:restaurant_id)
    end

    def set_walkin
      @walk_in = Booking.find(params[:id])
    end
end
