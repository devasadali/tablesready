App.message_notifications = App.cable.subscriptions.create('MessagesChannel',
  received: (data) ->
    response = data.response
    msg = response.msg
    if response.show_modal
      $(".msg_counter_notification").hide()
      $("#message_notification_modal .notification_message").text(msg)
      $("#message_notification_modal").modal('show')
    else
      $(".msg_counter_notification").text(msg).removeClass('hide')
  renderMessage: (data) ->
    console.log("in renderMessage: #{data}")
)