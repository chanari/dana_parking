$(document).ready ->

  $('#selectSlot').change ->
    if $(this).val() == '0'
      $('.result-parking').css('display', 'none')
      return

    $('#form-detail').find('.form-check-input').prop('checked', false)
    $('#form-detail').find('.select-month, .select-day').css('display', 'none')
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
