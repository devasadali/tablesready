window.App ||= {}
class App.Reservations extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    App.applyDatePicker($('.datepicker'))
    App.applyTimePicker($('.timepicker'))
    App.applyIntlInput($("#reservation_phone"))
    
    $reservationForm = $("#reservation_form")

    $.validator.addMethod 'validTimeCheck', ((time, element) ->
      date = $(".datepicker").val()
      time = new Date("#{date} #{time}")
      time > new Date()
    ), 'Please enter a valid future time.'

    $(document).on "click",".reset_form_btn", (event) ->
      event.preventDefault()
      prev_time = $("#reservation_booking_time").val()
      App.resetForm($reservationForm[0])
      # reset time value to only time
      $("#reservation_booking_time").val(prev_time)
      
    $reservationForm.submit (event) ->
      $($reservationForm).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        invalidHandler: (form, validator) ->
          return  unless validator.numberOfInvalids()
          $("html, body").animate
            scrollTop: $(validator.errorList[0].element).offset().top
          , 200

        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "reservation[booking_date]":
            required: true
          "reservation[booking_time]":
            required: true
            validTimeCheck: true
          "reservation[party_name]":
            required: true
          "reservation[size]":
            required: true
            number: true
          "reservation[phone]":
            required: true
            phoneCheck: true
      if $($reservationForm).valid()
        $(".submit_btn").attr("disabled",true)
        return true
      
      # Prevent the form from being submitted:
      false
    
    initBookingTime = ->
      # current time + 15 minutes
      time = new Date().getTime() + 15*60*1000
      time = new Date(time)
      hours = parseInt(time.getHours())
      minutes = parseInt(time.getMinutes())
      minutes = minutes - (minutes % 15)
      ampm = if hours >= 12 then 'PM' else 'AM'
      hours = hours % 12
      hours = if hours then hours else 12
      if hours < 10
        hours = "0#{hours}"
      if minutes < 10
        minutes = "0#{minutes}"
      time = "#{hours}:#{minutes} #{ampm}"
      $("#reservation_booking_time").val(time)

    initBookingTime()
    return


  show: =>
    return


  new: =>
    return


  edit: =>
    return

  # update form validation
  updateReservationFormValidator: ->
    $updateReservationForm = $("#reservation_update_form")

    $.validator.addMethod 'validUpdateTimeCheck', ((time, element) ->
      date = $("#edit_reservation_datepicker").val()
      time = new Date("#{date} #{time}")
      time > new Date()
    ), 'Please enter a valid future time.'
    
    $updateReservationForm.submit (event) ->
      $($updateReservationForm).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "reservation[booking_date]":
            required: true
          "reservation[booking_time]":
            required: true
            validUpdateTimeCheck: true
          "reservation[party_name]":
            required: true
          "reservation[size]":
            required: true
            number: true
          "reservation[phone]":
            required: true
            phoneCheck: true
      if $($updateReservationForm).valid()
        return true
      # Prevent the form from being submitted:
      false
    return

  import: =>
    $importCsvForm = $("#import_csv_form")
    $importCsvForm.submit (event) ->
      $($importCsvForm).validate
        focusInvalid: false
        errorClass: 'text-danger'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "csv_file":
            required: true
        messages:
          "csv_file":
            required: "CSV file is required."
      if $($importCsvForm).valid()
        return true
      # Prevent the form from being submitted:
      false
    return

