window.App ||= {}
class App.Pages extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  pricing: =>
    
    $(document).on "click",".walkin_subscribe_modal_lnk", (event) ->
      window.scroll(0,0)
      $("#walkin_subscribe_modal").modal("show")
      event.preventDefault()
      return false
    $(document).on "click",".subscription_lnk", (event) ->
      if $(this).hasClass('disabled')
        event.preventDefault()
        return false
      lnk = $(this).attr('lnk')
      method = $(this).data('method')
      plan_id = $(this).attr("plan_id")
      $("#subscription_form #plan_id").val(plan_id)
      $(this).addClass('btn-default')
      $(this).addClass('disabled')
      event.preventDefault()
      $.ajax
        url: lnk
        type: method
        data: $("#subscription_form").serialize()
        beforeSend: ->
          show_loader(plan_id)

    
    hide_loader =  ->
      $("html, body").animate
        scrollTop: $($alert).offset().top
      , 200
      $(".pre-loader").addClass('hide')

    show_loader = (plan_id) ->
      $(".plan-content[plan_id=#{plan_id}] .pre-loader").removeClass('hide')  
    return

  support: =>
    $form = $('#support_form')
    $form.submit (event) ->
      $($form).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "name":
            required: true
          "email":
            required: true
          "body":
            required: true
      if $($form).valid()
        $($form).find("button").attr("disabled",true)
        return true
      # Prevent the form from being submitted:
      false
    return

  thanks: =>
    if gon.redirect_to_path
      setTimeout ->
        window.location = gon.redirect_to_path
      , 5000
