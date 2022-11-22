window.App ||= {}
class App.Messages extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    templates = []
    $(".sortable").sortable
      scroll: false
      update: (event, ui) ->
        updateTemplatesOrder()

    $bulkMessageForm = $("#bulk_message_form")
    $bulkMessageForm.submit (event) ->
      $($bulkMessageForm).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "message[template]":
            required: true
      if $($bulkMessageForm).valid()
        return true
      # Prevent the form from being submitted:
      false

    updateTemplatesOrder = ->
      $(".sortable .message_template").each (index,element) ->
        templates.push({index: index,template_id: $(element).attr("template_id")})
      $.post "/message_templates/update_order",{'templates': templates}
      return

    return


  show: =>
    return


  new: =>
    return


  edit: =>
    return


  # update form validation
  messageTemplateFormValidator: ->
    $messageTemplateForm = $("#message_template_form")
    $messageTemplateForm.submit (event) ->
      $($messageTemplateForm).validate
        focusInvalid: false
        errorClass: 'invalid'
        validClass: 'valid'
        errorPlacement: (error, element) ->
          error.insertAfter $(element)

        rules:
          "message_template[name]":
            required: true
          "message_template[next_delay]":
            required: true
            number: true
          "message_template[template]":
            required: true
      if $($messageTemplateForm).valid()
        $($messageTemplateForm).find("button[type='submit']").attr('disabled',true)
        return true
      # Prevent the form from being submitted:
      false
    return
