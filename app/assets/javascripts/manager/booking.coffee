$(document).ready ->

  $('.btn-booking').click (e) ->
    e.preventDefault()
    slot_id = $('#slot-id').val()
    bks = $('#bks').val()
    number_plate = $('#bks').val()
    if slot_id == ''
      alertify.error("Ban chua chon cho")
      return
    if bks == ''
      alertify.error("Ban chua nhap BKS")
      return
    $.LoadingOverlay('show');
    $.ajax
      url: '/manager/booking/slot_book'
      type: 'POST'
      dataType: 'JSON'
      data:
        slot_id: slot_id
        number_plate: number_plate
      success: (data) ->
        $('#slot-' + slot_id).removeAttr('class')
        $('#slot-' + slot_id).addClass('selecting')
        $('#form-detail').trigger("reset")
        alertify.success("Thanh Cong !")
        return
      error: (data) ->
        alertify.error("That bai !!!")
        return
    $.LoadingOverlay('hide');
    return

  $('#selectSlot').change ->
    if $(this).val() == '0'
      $('.result-parking').css('display', 'none')
      return

    $('#form-detail').find('.form-check-input').prop('checked', false)
    $('#form-detail').find('.select-month, .select-day').css('display', 'none')
    $('#form-detail').find('.vitri').val('')
    $('#slot-id').val('')
    $.LoadingOverlay('show');
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
  return
