ActiveAdmin.register Booking do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  index do
    selectable_column
    id_column
    column :booking_date
    column :booking_time
    column :party_name
    column :size
    column :phone
    column :restaurant
    column :status
    column :checkin
    column :sequence_in_progress
  end

  csv do
    column :id
    column :party_name
    column :phone
    column :restaurant do |booking|
      booking.restaurant.name
    end
    column :size
    column :booking_date
    column :booking_time
    column :status
    column :checkin
    column :sequence_in_progress
  end
end
