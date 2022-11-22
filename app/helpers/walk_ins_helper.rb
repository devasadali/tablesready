module WalkInsHelper

  def booking_time_in_words booking
    t1 = booking.booking_time.in_time_zone(current_user.time_zone).strftime("%I:%M %p")
    t2 = Time.now.in_time_zone(current_user.time_zone).strftime("%I:%M %p")

    css_class = t1 < t2 ? "text-danger" : "text-navy"
    "<span class='counter #{css_class}'>
      (#{distance_of_time_in_words(t1,t2)})
    </span>".html_safe
  end

  def booking_seated_lnk booking
    if booking.checkin
      if booking.seated?
        button_tag class: "btn btn-primary disabled m-r-xs" do
          "<i class='fa fa-check m-r-xs'></i> <span> Seated </span>".html_safe
        end
      else
        link_to change_status_walk_in_path(booking,status: "seated"),method: :post,remote:true,class: "btn btn-default m-r-xs" do
          "<i class='fa fa-check m-r-xs'></i> <span> Seated </span>".html_safe
        end
      end
    else
      button_tag class: "btn btn-default disabled m-r-xs" do
        "<i class='fa fa-check m-r-xs'></i> <span> Seated </span>".html_safe
      end
    end
  end

  def booking_no_show_lnk booking
    if booking.no_show?
      button_tag class: "btn btn-primary disabled m-r-xs" do
        "<i class='fa fa-times m-r-xs'></i> <span> No Show </span>".html_safe
      end
    else
      link_to change_status_walk_in_path(booking,status: "no_show"),method: :post,remote:true,class: "btn btn-default m-r-xs" do
        "<i class='fa fa-times m-r-xs'></i> <span> No Show </span>".html_safe
      end
    end
  end
end
