window.App ||= {}
class App.Subscriptions extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    return


  show: =>
    return


  new: =>
    $form = $('#credit_card_form')
    $alert = $form.find('.payment-errors')

    ## ######################################################
    stripeResponseHandler = (status, response) ->
      # Grab the form:
      $form = $('#credit_card_form')
      if response.error
        # Problem!
        # Show the errors on the form:
        hide_loader()
        $alert.html response.error.message
        $alert.addClass("alert-warning")
        $form.find('.submit').prop 'disabled', false
        # Re-enable submission
      else
        # Token was created!
        # Get the token ID:
        token = response.id
        # Insert the token ID into the form so it gets submitted to the server:
        $form.append $('<input type="hidden" name="stripeToken">').val(token)
        # Submit the form:
        $.post $form.attr("url"), $form.serialize(), (data)->
          if data.error
            hide_loader()
            $alert.html data.message
            $alert.addClass("alert-warning")
            $form.find('.submit').prop 'disabled', false
            # Re-enable submission
          else
            plan_id = $("#plan_id").val()
            ## Create Subscription
            $.post "/subscriptions",$form.serialize() , (data)->
              if data.error
                hide_loader()
                $alert.html data.message
                $alert.addClass("alert-warning")
                $form.find('.submit').prop 'disabled', false
                # Re-enable submission
              else
                $alert.html("Redirecting now ...")
                $alert.addClass("alert-success")
                window.location = "/"

      return


    $form.submit (event) ->
      $($form).validate
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
          "name":
            required: true
          "number":
            required: true
          "exp_month":
            required: true
            number: true
          "exp_year":
            required: true
            number: true
          "cvc":
            required: true
            number: true

        messages:
          "name":
            required: "Card holder name is required."
          "number":
            required: "Card number is required."
          "exp_month":
            required: "Expiry month is required."
            number: "Card expiry month is not valid."
          "exp_year":
            required: "Expiry year is required."
            number: "Card expiry year is not valid."
          "cvc":
            required: "CVC number is required."
            number: "CVC number is not valid."
      if $($form).valid()
        show_loader()
        # Disable the submit button to prevent repeated clicks:
        $form.find('.submit').prop 'disabled', true

        # Request a token from Stripe:
        Stripe.card.createToken $form, stripeResponseHandler
      # Prevent the form from being submitted:
      false
    

    hide_loader = ->
      $("html, body").animate
        scrollTop: $($alert).offset().top
      , 200
      $(".pre-loader").addClass('hide')

    show_loader = ->
      $(".pre-loader").removeClass('hide')  
    return


  edit: =>
    return


  update_payment_info: =>
    $form = $('#credit_card_form')
    $alert = $form.find('.payment-errors')

    ## ######################################################
    stripeResponseHandler = (status, response) ->
      # Grab the form:
      $form = $('#credit_card_form')
      if response.error
        # Problem!
        # Show the errors on the form:
        hide_loader()
        $alert.html response.error.message
        $alert.addClass("alert-warning")
        $form.find('.submit').prop 'disabled', false
        # Re-enable submission
      else
        # Token was created!
        # Get the token ID:
        token = response.id
        # Insert the token ID into the form so it gets submitted to the server:
        $form.append $('<input type="hidden" name="stripeToken">').val(token)
        # Submit the form:
        $.post $form.attr("url"), $form.serialize(), (data)->
          if data.error
            hide_loader()
            $alert.html data.message
            $alert.addClass("alert-warning")
            $form.find('.submit').prop 'disabled', false
            # Re-enable submission
          else
            $.post "/subscriptions/update_payment_info", $form.serialize(), (data)->
              if data.error
                hide_loader()
                $alert.html data.message
                $alert.addClass("alert-warning")
                $form.find('.submit').prop 'disabled', false
                # Re-enable submission
              else
                $alert.html("Redirecting now ...")
                $alert.addClass("alert-success")
                window.location = "/subscriptions"
      return


    $form.submit (event) ->
      $($form).validate
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
          "name":
            required: true
          "number":
            required: true
          "exp_month":
            required: true
            number: true
          "exp_year":
            required: true
            number: true
          "cvc":
            required: true
            number: true

        messages:
          "name":
            required: "Card holder name is required."
          "number":
            required: "Card number is required."
          "exp_month":
            required: "Expiry month is required."
            number: "Card expiry month is not valid."
          "exp_year":
            required: "Expiry year is required."
            number: "Card expiry year is not valid."
          "cvc":
            required: "CVC number is required."
            number: "CVC number is not valid."
      if $($form).valid()
        show_loader()
        # Disable the submit button to prevent repeated clicks:
        $form.find('.submit').prop 'disabled', true

        # Request a token from Stripe:
        Stripe.card.createToken $form, stripeResponseHandler
      # Prevent the form from being submitted:
      false


    hide_loader = ->
      $("html, body").animate
        scrollTop: $($alert).offset().top
      , 200
      $(".pre-loader").addClass('hide')

    show_loader = ->
      $(".pre-loader").removeClass('hide')
    return

