$('.modal').on 'hidden.bs.modal', ->
  $(this).find('form').trigger('reset')
  return

$(document).on 'click', 'ul.slot-list-items li a', ->
  slot_id = $(this).attr('id').split('-')[1]
  if $(this).hasClass('reservation')
    $.LoadingOverlay('show')
    $.ajax
      url: '/manager/booking/get_reserve_detail'
      type: 'GET'
      dataType: 'JSON'
      data:
        slot_id: slot_id
      success: (data) ->
        $('#slot-reserve').find('input.slot-id').val(data.id)
        $('#slot-reserve').find('input.bks').val(data.number_plate)
        $('#slot-reserve').find('input.timein').val(monthFormat(data.date_in))
        $('#slot-reserve').modal('show')
        return
      error: (data) ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')

  else if $(this).hasClass('selecting')
    $.LoadingOverlay('show')
    $.ajax
      url: '/manager/booking/get_slot_detail'
      type: 'GET'
      dataType: 'JSON'
      data:
        slot_id: slot_id
      success: (data) ->
        if data.is_paid == true
          $('#slot-paid').find('form input.bks').val(data.number_plate)
          $('#slot-paid').find('form input.type').val(if data.is_monthly == true then 'Tháng' else 'Ngày')
          $('#slot-paid').find('form input.timein').val(monthFormat(data.timein))
          $('#slot-paid').find('form input.timeout').val(monthFormat(data.timeout))
          $('#slot-paid').find('form input.price').val(data.price)
          $('#slot-paid').find('form input.subtotal').val(data.subtotal)
          $('#slot-paid').modal('show')
          return
        $('#slot-detail').find('form input.reserve-id').val(data.id)
        $('#slot-detail').find('form input.bks').val(data.number_plate)
        $('#slot-detail').find('form input.type').val(if data.is_monthly == true then 'Tháng' else 'Ngày')
        $('#slot-detail').find('form input.timein').val(dateFormat(data.timein))
        $('#slot-detail').find('form input.price').val(data.price)
        $('#slot-detail').find('form input.alltime').val(data.total_time)
        $('#slot-detail').find('form input.subtotal').val(data.total_time * data.price)
        $('#slot-detail').modal('show')
        # console.log data
        return
      error: (data) ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')
    return
  return

$(document).ready ->

  $('.btn-booking').click (e) ->
    e.preventDefault()
    slot_id = $('#slot-id').val()
    bks = $('#bks').val()
    number_plate = $('#bks').val()
    if slot_id == ''
      alertify.error("Bạn chưa chọn chỗ")
      return
    if bks == ''
      alertify.error("Bạn chưa nhập BKS")
      return
    $.LoadingOverlay('show')
    quantity = $('input[name=quantity]').val()
    type = $('input[name=inlineRadioOptions]:checked').val()
    $.ajax
      url: '/manager/booking/slot_book'
      type: 'POST'
      dataType: 'JSON'
      data:
        slot_id: slot_id
        number_plate: number_plate
        quantity: quantity
        type: type
      success: (data) ->
        $('#slot-' + slot_id).removeAttr('class')
        $('#slot-' + slot_id).addClass('selecting')
        $('#form-detail').trigger("reset")
        alertify.success("Thanh Cong !")
        $('.select-month, .select-day').css('display', 'none')
        $('#form-detail').find('.options').css('display','none')
        return
      error: (data) ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')
    return

  $('#btn-pay').click ->
    reserve_id = $(this).closest('.modal').find('input.reserve-id').val()
    $.LoadingOverlay('show')
    $.ajax
      url: '/manager/booking/pay'
      type: 'PUT'
      dataType: 'JSON'
      data:
        reserve_id: reserve_id
      success: (data) ->
        $('#slot-' + data.parking_slot_id).removeAttr('class')
        $('#slot-detail').modal('hide')
        alertify.success("Thành Công !")
        return
      error: (data) ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')
    return

  $('#selectSlot').change ->
    if $(this).val() == '0'
      $('.result-parking').css('display', 'none')
      return

    $('#form-detail').find('.options').css('display','none')
    $('#form-detail').trigger("reset")
    $('#form-detail').find('.select-month, .select-day').css('display', 'none')
    $.LoadingOverlay('show')
    n = 0
    size = $(this).val()
    $.ajax
      url: '/manager/booking/load_park'
      type: 'GET'
      dataType: 'JSON'
      data:
        size: size
      success: (data) ->
        $('#resultTab').find('li').not(':first').remove()
        $('#resultTabContent').find('.tab-pane').not(':first').remove()
        $.each data, (i, floor) ->
          price_hours = floor.price_by_hours
          price_month = floor.price_by_months
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
              result_tab.find('.slot-list-items').append '<li class="col-2 slot-item"> <a id="slot-'+slots.id+'" class="'+slots.status+'" href="javascript:void(0)" data-p-hours="'+price_hours+'" data-p-months="'+price_month+'">'+slots.name+'</a></li>'
              return
            $('#resultTabContent').append result_tab
            return
          return
        delayLoading()
        $('.result-parking').css({display: 'block'})
        return
      error: (data) ->
        return
    return

  $('#btn-cancel').click ->
    slot_id = $('#slot-reserve').find('input.slot-id').val()
    if slot_id < 0
      alertify.error("Thất bại !!!")
      return
    $.LoadingOverlay('show')
    $.ajax
      url: '/manager/booking/cancel_reserve'
      type: 'PUT'
      data:
        slot_id: slot_id
      dataType: 'JSON'
      success: (data) ->
        $('#slot-'+slot_id).removeAttr('class')
        $('#slot-reserve').trigger('reset')
        $('#slot-reserve').modal('hide')
        alertify.success("Thành Công !")
        return
      error: ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')
    return

  $('#btn-accept').click ->
    slot_id = $('#slot-reserve').find('input.slot-id').val()
    bks = $('#slot-reserve').find('input.bks').val()
    if slot_id < 0 || bks == ''
      alertify.error("Thất bại !!!")
      return
    $.LoadingOverlay('show')
    $.ajax
      url: '/manager/booking/accept_reserve'
      type: 'POST'
      data:
        slot_id: slot_id
        bks: bks
      dataType: 'JSON'
      success: (data) ->
        $('#slot-'+slot_id).removeAttr('class')
        $('#slot-'+slot_id).addClass('selecting')
        $('#slot-reserve').trigger('reset')
        $('#slot-reserve').modal('hide')
        alertify.success("Thành Công !")
        return
      error: ->
        alertify.error("Thất bại !!!")
        return
    $.LoadingOverlay('hide')
    return

  $('.btn-search').click ->
    bks = $('.findBKS .bks').val()
    return false unless bks.length > 0
    $.ajax
      url: '/manager/booking/find_bks'
      type: 'GET'
      data:
        bks: bks
      dataType: 'JSON'
      success: (data) ->
        console.log data
        $('#span-park').html data.park
        $('#span-size').html data.size
        $('#span-slotname').html data.slotname
        $('.collapse').collapse('show')
        return
      error: ->
        $('.collapse').collapse('hide')
        alertify.error("Thất bại !!!")
        return
    return

  return
