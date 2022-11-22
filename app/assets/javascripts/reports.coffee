window.App ||= {}
class App.Reports extends App.Base

  beforeAction: (action) =>
    return


  afterAction: (action) =>
    return


  index: =>
    App.applyDatePicker($("#reports_from"),true)
    App.applyDatePicker($("#reports_to"),true)

    $reportsForm = $("#reports_form")
    $reportsForm.submit (event) ->
      $($reportsForm).validate
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
          "reports[from]":
            required: true
          "reports[to]":
            required: true
            # validDateCheck: true
      if $($reportsForm).valid()
        $(".submit_btn").attr("disabled",true)
        return true
      # Prevent the form from being submitted:
      false


    generateGraph = (json_data)->
      lineOptions = {
        scaleShowGridLines: true,
        scaleGridLineColor: "rgba(0,0,0,.05)",
        scaleGridLineWidth: 1,
        bezierCurve: true,
        bezierCurveTension: 0.2,
        pointDot: true,
        pointDotRadius: 4,
        pointDotStrokeWidth: 1,
        pointHitDetectionRadius: 20,
        datasetStroke: true,
        datasetStrokeWidth: 2,
        datasetFill: false,
        responsive: true,
      }
      time_labels = [
        "12:00 AM"
        "01:00 AM"
        "03:00 AM"
        "04:00 AM"
        "05:00 AM"
        "06:00 AM"
        "07:00 AM"
        "08:00 AM"
        "09:00 AM"
        "10:00 AM"
        "11:00 AM"
        "12:00 PM"
        "01:00 PM"
        "02:00 PM"
        "03:00 PM"
        "04:00 PM"
        "05:00 PM"
        "06:00 PM"
        "07:00 PM"
        "08:00 PM"
        "09:00 PM"
        "10:00 PM"
        "11:00 PM"
      ]
      barData = []
      hour = 0

      while hour < 24
        barData.push(json_data[hour])
        hour +=1

      lineData = {
        labels: time_labels
        datasets: [
            {
                label: "Booking Activity per Hour",
                fillColor: "rgba(26,179,148,0.5)",
                strokeColor: "rgba(26,179,148,0.7)",
                pointColor: "rgba(26,179,148,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(26,179,148,1)",
                data: barData
            }
        ]
      }
      ctx = document.getElementById("lineChart").getContext("2d")
      new Chart(ctx).Line(lineData, lineOptions)
      return
    generateGraph(gon.hourly_bookings_json)
    return


  show: =>
    return


  new: =>
    return


  edit: =>
    return