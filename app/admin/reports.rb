ActiveAdmin.register_page "Reports" do


  sidebar :filters, partial: 'filters'

  content title:  "User Reports with total no. of subscribers" do
    if params[:reports]
      @from = params[:reports][:from]
      @to = params[:reports][:to]
    else
      @from  = Date.today - 1.month
      @to = Date.today
    end
    @from = @from.to_date.beginning_of_day
    @to = @to.to_date.end_of_day
    
    users = User.where('created_at >= ?', 1.week.ago).sort_by{|user| user.restaurant.messages.text_ready.where(created_at: [@from .. @to]).count}.reverse
    columns do
      column do
        panel "Subscribers" do
          table do
            thead do
              th "Name"
              th "Email"
              th "No. of Subscribers"
              th "No. of Wait List SMS Sent"
              th "No. of Marketing SMS Sent"
            end

            tbody do
              users.each do |user|
                restaurant = user.restaurant
                tr do
                  td user.name
                  td user.email
                  td restaurant.customers.count
                  td restaurant.messages.text_ready.where(created_at: [@from .. @to]).count
                  td restaurant.messages.marketing.where(created_at: [@from .. @to]).count
                end if restaurant
              end
            end
          end
        end
      end
    end
  end

  action_item :export_reports do
    if params[:reports]
      @from = params[:reports][:from]
      @to = params[:reports][:to]
    else
      @from  = Date.today - 1.month
      @to = Date.today
    end
    link_to "Export User Reports", admin_reports_download_csv_path(format: :csv,from: @from,to: @to)
  end

  controller do
    def download_csv
      options = {}

      @from = params[:from].to_date.beginning_of_day
      @to = params[:to].to_date.end_of_day

      header_columns = [
        "Name",
        "Email",
        "No. of Subscribers",
        "No. of Wait List SMS Sent",
        "No. of Marketing SMS Sent"
      ]

      csv_data = CSV.generate(options) do |csv|
        csv << header_columns
        User.where('created_at >= ?', 1.week.ago).each do |user|
          restaurant = user.restaurant
          row = [
            user.name,
            user.email,
            restaurant.customers.count,
            restaurant.messages.text_ready.where(created_at: [@from .. @to]).count,
            restaurant.messages.marketing.where(created_at: [@from .. @to]).count
          ]
          csv << row if restaurant
        end
      end
      send_data(csv_data,filename: "USERS-REPORT.csv")
    end
  end
end

