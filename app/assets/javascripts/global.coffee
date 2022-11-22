##########################################################
## All the regular experession validators will be
## defined in this method: FormValidators
## Scope: Globally used throughout the application
## Author: Sarwan Kumar
App.formValidators = ->
  $.validator.addMethod 'phoneCheck', ((phone_number, element) ->
    # # set country to US, currently only US number accepted.
    # $(element).intlTelInput("setCountry", "us");
    $(element).intlTelInput("isValidNumber")
  ), 'Please enter a valid phone number'

############# END OF Method: FormValidators ##############
##########################################################

#### signin form validations ####
App.signinFormValidator = ->
  $("#signin_form").validate
    errorClass: 'invalid'
    validClass: 'valid'
    errorPlacement: (error, element) ->
      error.insertAfter $(element)

    rules:
      "user[email]":
        required: true
        email: true
      "user[password]":
        required: true
    messages:
      "user[email]":
        required: "Email is required."
        email: "Please enter a valid email address."

      "user[password]":
        required: "Password is required."

#### signup form validations ####
App.signUpFormValidator = ->
  App.applyIntlInput($("#user_phone"))
  # to set phone in proper format.
  setTimeout (->
    $('#user_phone').trigger 'change'
    return
  ), 3000
  $("#signup_form").validate
    errorClass: 'invalid'
    validClass: 'valid'
    errorPlacement: (error, element) ->
      error.insertAfter $(element)

    rules:
      "restaurant_name":
        required: true
      "user[name]":
        required: true
      "user[email]":
        required: true
        email: true
      "user[phone]":
        required: true
        phoneCheck: true
      "user[password]":
        minlength: 8
        required: true

      "user[password_confirmation]":
        required: true
        minlength: 8
        equalTo: "#user_password"
    messages:
      "restaurant_name":
        required: "Restaurant Name is required."
      "user[name]":
        required: "Name is required."
      "user[email]":
        required: "Email is required."
        email: "Please enter a valid email address."

      "user[password]":
        required: "Password is required."

      "user[password_confirmation]":
        required: "Confirm password is required."
        equalTo: "Password and Confirm Password does not match."


#### new password form validations ####
App.newPasswordFormValidator = ->
  $("#new_password_form").validate
    errorClass: 'invalid'
    validClass: 'valid'
    errorPlacement: (error, element) ->
      error.insertAfter $(element)

    rules:
      "user[email]":
        required: true
        email: true
    messages:
      "user[email]":
        required: "Email is required."
        email: "Please enter a valid email address."

#### edit password form validations ####
App.editPasswordFormValidator = ->
  $("#edit_password_form").validate
    errorClass: 'invalid'
    validClass: 'valid'
    errorPlacement: (error, element) ->
      error.insertAfter $(element)

    rules:
      "user[password]":
        minlength: 8
        required: true

      "user[password_confirmation]":
        required: true
        minlength: 8
        equalTo: "#user_password"
    messages:
      "user[password]":
        required: "Password is required."
      "user[password_confirmation]":
        required: "Confirm password is required."
        equalTo: "Password and Confirm Password does not match."

# reset form hanlder
App.resetForm = ($element)->
  $element.reset()


App.applyDatePicker = (element,prev = false)->
  # can select previous date, if prev is true
  # default prev: false
  minDate = new Date() unless prev
  $(element).datepicker
    dateFormat: "mm/dd/yy"
    altFormat: "mm/dd/yy"
    minDate: minDate unless prev

App.applyTimePicker = (element) ->
  $(element).datetimepicker
    datepicker:false
    format:'h:i A'
    formatTime: "h:i A"
    step: 15

App.applyIntlInput = ($element) ->
  $element.intlTelInput
    initialCountry: 'us'
    formatOnInit: true
    separateDialCode: false
    # onlyCountries: ['us']
    utilsScript: "assets/libphonenumber/utils.js"
    geoIpLookup: (callback) ->
      $.get('https://ipinfo.io', (->
      ), 'jsonp').always (resp) ->
        countryCode = if resp and resp.country then resp.country else ''
        callback countryCode
        return
      return

  $element.on 'change', ->
    App.setIntlValue($element)

  # default set initial value.
  App.setIntlValue($element)

App.setIntlValue = ($element) ->
  intlNumber = $element.intlTelInput('getNumber')
  if intlNumber
    $element.val intlNumber

App.countChar = ($element) ->
  count = $element.value.length
  $($element).parent().find(".character-count").text(count)

