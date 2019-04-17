App.booking = App.cable.subscriptions.create "BookingChannel",
  connected: ->
    console.log 'Connected'

  disconnected: ->
    console.log 'Disconnected'

  received: (data) ->
    if data.status == '0'
      $('#slot-'+data.id).removeAttr('class')
