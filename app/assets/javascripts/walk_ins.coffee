window.App ||= {}
class App.WalkIns extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    $walkinForm = $("#walk_in_form")
    App.applyIntlInput($("#walk_in_phone"))

    $(document).on "click",".reset_form_btn", (event) ->
      event.preventDefault()
      App.resetForm($walkinForm[0])
      
    $walkinForm.submit (event) ->
      $($walkinForm).validate
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
          "walk_in[wait_in_minutes]":
            required: true
          "walk_in[party_name]":
            required: true
          "walk_in[size]":
            required: true
            number: true
          "walk_in[phone]":
            required: true
            phoneCheck: true
      if $($walkinForm).valid()
        minutes = parseInt($("#time_in_minutes").val())
        time = calculateTime(minutes)
        $("#walk_in_booking_time").val(time)
        $(".submit_btn").attr("disabled",true)
        return true
      # Prevent the form from being submitted:
      false


    # current time plus minutes
    calculateTime = (minutes) ->
      currentTime = new Date()
      # get time in milliseconds
      currentTime = (currentTime.getTime() + minutes*60*1000)
      bookingTime = new Date(currentTime)
      bookingTime = "#{bookingTime.getFullYear()}-#{bookingTime.getMonth()}-#{bookingTime.getDate()} #{bookingTime.getHours()}:#{bookingTime.getMinutes()}"
      return bookingTime

    WalkIns.prototype.walkinList = ->
      count = $(".walk_ins tr").length
      intervals = intervals || {}
      if count > 0
        $(".walk_ins tr").each (index,tr) ->
          id = $(tr).attr('id')
          WalkIns.prototype.setBookingRemainingTime(id)
          intervals[id] << setInterval ->
            WalkIns.prototype.setBookingRemainingTime(id)
          ,60000

    WalkIns.prototype.setBookingRemainingTime = (element_id) ->
      if $("##{element_id}").length > 0
        bookingTime = $("##{element_id}").find('.booking_time').attr('time')
        time1 = new Date(bookingTime)
        time2 = new Date()
        diff =  moment(time1).from(time2);
        if time1 < time2
          css_class = "text-danger"
        else
          css_class = "text-navy"

        html = "
          <span class='counter #{css_class}'>
            (#{diff})
          </span>
        "
        $("##{element_id} .counter").replaceWith(html)
    this.walkinList()



    return



  show: =>
    return


  new: =>
    return


  edit: =>
    return

  # update form validation
  updateWalkinFormValidator: ->
    $updateWalkinForm = $("#walk_in_update_form")
    $updateWalkinForm.submit (event) ->
      $($updateWalkinForm).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "walk_in[party_name]":
            required: true
          "walk_in[size]":
            required: true
            number: true
          "walk_in[phone]":
            required: true
            phoneCheck: true
      if $($updateWalkinForm).valid()
        return true
      # Prevent the form from being submitted:
      false
    return
