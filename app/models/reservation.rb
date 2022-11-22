require "csv"
class Reservation < Booking
  after_save :set_noshow_job
  
  def self.import restaurant, csv_file
    @reservations = []
    begin
      if csv_file.present?
        content_type = csv_file.content_type
        if content_type.include?("csv") or content_type.include?('octet-stream')
          CSV.foreach(csv_file.path) do |row|
            puts "row: #{row}"
            @reservations << Reservation.new(booking_date: row[0],booking_time: row[0],party_name: row[1],size: row[2],phone: row[3],notes: row[4],restaurant_id: restaurant.id)
          end
          response = {error: false,message: "CSV file is imported successfully!"}
        else
          response = {error: true,message: "File is not supported, Please upload CSV file in proper format of data."}
        end
      else
        response = {error: true,message: "File not found, Please upload CSV file in proper format of data."}
      end
    rescue Exception => e
      puts "Error! #{e.message}"
      response = {error: true,message: "File is not supported, Please upload CSV file in proper format of data."}
    end

    @reservations.map(&:save) unless response[:error]
    return response
  end
end
