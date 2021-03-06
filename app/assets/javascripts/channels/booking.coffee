App.booking = App.cable.subscriptions.create "BookingChannel",
  connected: ->
    console.log 'Connected'

  disconnected: ->
    console.log 'Disconnected'

  received: (data) ->
    $('#slot-'+data.id).removeAttr('class')
    switch data.status
      when '1'
        $('#slot-'+data.id).addClass('reservation')
      when '2'
        $('#slot-'+data.id).addClass('selecting')
