$(document).ready ->

  $('#selectPark').change ->
    $('#selectSlot').val('0')
    $('#price-hours').val('')
    $('#slot-id').val('')
    $('.result-parking').css({display: 'none'})
    if parseInt($('#selectPark').val(), 10) > 0
      $('.result-parking').find('input.baixe').val($(this).find('option:selected').text())
    else
      $('.result-parking').find('input.baixe').val('')
      $('.result-parking').find('input.vitri').val('')
    return

  $('#selectSlot').change ->
    $('.result-parking').find('input.vitri').val('')
    $('#price-hours').val('')
    $('#slot-id').val('')
    n = 0
    park_id = $('#selectPark').val()
    block_size = $('#selectSlot').val()
    if(park_id == '0' || block_size == '0')
      $('.result-parking').css({display: 'none'})
      return

    $.LoadingOverlay('show')
    $.ajax
      url: '/client/booking/get_floors'
      type: 'GET'
      dataType: 'JSON'
      data:
        park_id: park_id
        block_size: block_size
      success: (data) ->
        $('#resultTab').find('li').not(':first').remove()
        $('#resultTabContent').find('.tab-pane').not(':first').remove()
        $.each data, (i, floor) ->
          price_hours = floor.price_by_hours
          $.each floor.blocks, (ii, blocks) ->
            nav_tab = $('#resultTab').find('.nav-item').eq(0).clone()
            nav_tab.removeAttr('style')
            nav_tab.find('a').attr('href', '#block'+blocks.id)
            nav_tab.find('a').attr('aria-controls', blocks.id)
            if n == 0
              nav_tab.find('a').attr('aria-selected','true')
              nav_tab.find('a').addClass('active')
              n = n + 1
            nav_tab.find('a').html blocks.name
            $('#resultTab').append nav_tab

            result_tab = $('#resultTabContent').find('.tab-pane').eq(0).clone()
            result_tab.removeAttr('style')
            result_tab.attr('id', 'block'+blocks.id)
            result_tab.attr('aria-labelledby', blocks.id + '-tab')
            if n == 1
              result_tab.addClass('active')
              n = n + 1
            $.each blocks.parking_slots, (iii, slots) ->
              switch slots.status
                when '0'
                  slots.status = ''
                when '1'
                  slots.status = 'reservation'
                when '2'
                  slots.status = 'selecting'
              result_tab.find('.slot-list-items').append '<li class="col-2 slot-item"> <a id="slot-'+slots.id+'" class="'+slots.status+'" href="javascript:void(0)" data-p-hours="'+price_hours+'">'+slots.name+'</a></li>'
              return
            $('#resultTabContent').append result_tab
            return
          return
        delayLoading()
        $('.result-parking').css({display: 'block'})
        return
      error: (data) ->
        $.LoadingOverlay('hide')
        alertify.error("Thất Bại !")
        return
    return

  $('#btn-booking').click (e) ->
    e.preventDefault()
    slot_id = $('#slot-id').val()
    number_plate = $('#client-booking').find('input.bks').val()
    if slot_id < 0
      alertify.error("Thất Bại !")
      return
    $.LoadingOverlay('show')
    $.ajax
      url: '/client/booking'
      type: 'POST'
      dataType: 'JSON'
      data:
        slot_id: slot_id
        number_plate: number_plate
      success: (data) ->
        $('#slot-'+slot_id).removeAttr('class')
        $('#slot-'+slot_id).addClass('reservation')
        $('#client-booking').trigger('reset')
        if $('#selectPark').val() == 0
          $('.result-parking').find('input.baixe').val('')
        else
          $('.result-parking').find('input.baixe').val($('#selectPark').find('option:selected').text())
        delayLoading()
        alertify.success("Thành Công !")
        return
      error: (data) ->
        $('#client-booking').trigger('reset')
        if $('#selectPark').val() == 0
          $('.result-parking').find('input.baixe').val('')
        else
          $('.result-parking').find('input.baixe').val($('#selectPark').find('option:selected').text())
        $.LoadingOverlay('hide')
        alertify.error("Thất Bại !")
        return
    return

  return
