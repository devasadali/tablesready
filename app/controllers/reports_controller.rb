class ReportsController < ApplicationController
  before_action :set_report_dates
  def index
    start_time = @from.beginning_of_day
    end_time = @to.end_of_day
    @bookings = Booking.unscoped.by_restaurant(my_restaurant).where(created_at: [start_time .. end_time])
    @bookings_count = @bookings.size
    @new_bookings_count = @bookings.new_bookings.size
    @seated_count = @bookings.seated.size
    @no_show_count = @bookings.no_show.size
    @cancelled_count = @bookings.cancelled.size
    gon.hourly_bookings_json = calculate_activity_per_hour(@bookings)
    calculate_wait_timings(@bookings)
  end

  def customer_csv
    @customers = my_restaurant.customers.includes(:bookings)
    respond_to do |format|
      format.html
      format.csv { send_data(Customer.to_csv(@customers),filename: "#{my_restaurant.name.upcase}-CUSTOMERS.csv") }
      format.js { render layout: false }
    end
  end

  def booking_csv
    start_time = @from.beginning_of_day
    end_time = @to.end_of_day
    @bookings = Booking.unscoped.by_restaurant(my_restaurant).where(created_at: [start_time .. end_time])
    respond_to do |format|
      format.html
      format.csv { send_data(Booking.to_csv(@bookings),filename: "#{my_restaurant.name.upcase}-#{start_time.strftime('%Y%m%d')}_#{end_time.strftime('%Y%m%d')}-BOOKINGS.csv") }
      format.js { render layout: false }
    end
  end

  

  private
    def calculate_activity_per_hour bookings
      hourly_bookings = bookings.group_by(&:created_hour)
      # make data in json of all 24 hours
      data = {}
      (0..23).each do |hour|
        hour = hour < 10 ? "0#{hour}": "#{hour}"
        data[hour.to_i] = hourly_bookings[hour].blank? ? 0 : hourly_bookings[hour].size
      end
      data
    end
    def calculate_wait_timings bookings
      bookings = bookings.select("avg(wait_in_minutes) as avg_time,max(wait_in_minutes) as max_time")
      if bookings.any?
        @longest_wait_time = bookings[0].try(:max_time).to_i
        @avg_wait_time = bookings[0].try(:avg_time).to_i
      else
        @longest_wait_time = 0
        @avg_wait_time = 0
      end
    end
    
    def set_report_dates
      @from = Date.today - 7.days
      @to = Date.today
      if params[:reports]
        from_date = params[:reports][:from].to_s.split("/")
        to_date = params[:reports][:to].to_s.split("/")
        @from = "#{from_date[2]}-#{from_date[0]}-#{from_date[1]}".to_date
        @to = "#{to_date[2]}-#{to_date[0]}-#{to_date[1]}".to_date
      end
    end
end
