class ReservationsController < ApplicationController
  before_action :set_reservation,only: [:edit,:update,:destroy,:change_status]

  def index
    @reservations = Reservation.by_restaurant(my_restaurant).order(:booking_date).order(:booking_time)
    @reservation = Reservation.new(size: 2,restaurant_id: my_restaurant.id,booking_date: Date.today)
  end

  def new
    @reservation = Reservation.new(size: 2,restaurant_id: my_restaurant.id,booking_date: Date.today)
  end

  def import
  end

  def upload
    response = Reservation.import(my_restaurant,params[:csv_file])
    if response[:error]
      redirect_to import_reservations_path,alert: response[:message]
    else
      redirect_to reservations_path,notice: response[:message]
    end
  end

  def create
    @reservation = Reservation.create(reservation_params)
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
    @from = params[:from]
    @reservation.update(reservation_params)
    @reservation.set_customer
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def change_status
    @reservation.send("#{params[:status]}!")
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def destroy
    @reservation.cancelled!
    @reservation.destroy
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  private

    def reservation_params
      booking_date = params[:reservation][:booking_date]
      if booking_date.include?("/")
        params[:reservation][:booking_date] = Date.strptime(booking_date,"%m/%d/%Y")
      end
      params.require(:reservation).permit(:booking_date,:booking_time,:size,:phone,:party_name,:notes,:restaurant_id)
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
end
