App.bookings = App.cable.subscriptions.create('WalkinsChannel',
  received: (data) ->
    id = data.booking.id
    $("#booking_#{id}").remove()
  renderMessage: (data) ->
    console.log("in renderMessage: #{data}")
)

App.message_sequence = App.cable.subscriptions.create('MessageSequenceChannel',
  received: (data) ->
    elem_id = "booking_#{data.booking_id}"
    $("##{elem_id}").replaceWith(data.html_template)
    new App.WalkIns().setBookingRemainingTime(elem_id);
  renderMessage: (data) ->
    console.log("in renderMessage: #{data}")
)