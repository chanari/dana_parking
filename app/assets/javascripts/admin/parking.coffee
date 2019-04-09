$(document).on 'click', '.btn-block', (e) ->
  e.preventDefault()
  rm_block =
    '<div class="form-group" style="margin-left: 20px;">
    <a href="javascript:void(0)" class="btn-rm-blocks">
    <i class="fas fa-trash"></i>
    </a>
    </div>'
  obj = $(this).closest('.form-floors').find('.form-blocks').eq(0).clone()
  obj.find('.row').eq(0).remove()
  obj.find('.form-inline').append rm_block
  clearInputs(obj)
  renameCloneIdsAndNames(obj, 'parking[floors_attributes]', 2)
  $(this).closest('fieldset.scheduler-border').find('.form-blocks').last().after obj
  return

$(document).on 'click', '.btn-reset', (e) ->
  e.preventDefault()
  $(this).closest('.form-floors').find('select.form-control').val ''
  $(this).closest('.form-floors').find('input.form-control').each ->
    $(this).val ''
    return
  return

$(document).on 'click', '.btn-rm-blocks', ->
  $(this).closest('.form-blocks').remove()
  return

$(document).on 'click', '.rm-floors', ->
  $(this).closest('.form-floors').remove()
  updateFloors('form-floors')
  return

$(document).ready ->
  $('#btn-floor').click (e) ->
    e.preventDefault()
    rm_floor = '<a href="javascript:void(0)" class="rm-floors"><i class="fas fa-minus-circle fa-lg"></i></a>'
    obj = $('.form-floors').eq(0).clone()
    obj.find('legend.scheduler-border').after rm_floor
    clearInputs(obj)
    obj.find('.form-blocks').not(':first').remove()
    renameCloneIdsAndNames(obj, 'parking[floors_attributes]', 1)
    $('.form-floors').last().after obj
    updateFloors('form-floors')
    return

  $('#selectPark').change ->
    $('#selectSlot').val('0')
    parking_id = $(this).val()
    if parking_id > 0
      $.ajax
        url: '/admin/managers/get_manager'
        type: 'GET'
        dataType: 'JSON'
        data:
          parking_id: parking_id
        success: (data) ->
          console.log data
          $('#manager-name').html(data.first_name + ' ' + data.last_name)
          return
        error: (data) ->
          $('#manager-name').html 'Chua co'
          return
    else
      $('#manager-name').empty()
    $('.result-parking').css({display: 'none'})
    return

  $('#selectSlot').change ->
    n = 0
    park_id = $('#selectPark').val()
    block_size = $('#selectSlot').val()
    if(park_id == '0' || block_size == '0')
      $('.result-parking').css({display: 'none'})
      return

    $.LoadingOverlay('show');
    $.ajax
      url: '/admin/parking/get_floors'
      type: 'GET'
      dataType: 'JSON'
      data:
        park_id: park_id
        block_size: block_size
      success: (data) ->
        $('#resultTab').find('li').not(':first').remove()
        $('#resultTabContent').find('.tab-pane').not(':first').remove()
        $.each data, (i, floor) ->
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
              result_tab.find('.slot-list-items').append '<li class="col-2 slot-item"> <a id="slot-'+slots.id+'" class="'+slots.status+'" href="javascript:void(0)">'+slots.name+'</a></li>'
              return
            $('#resultTabContent').append result_tab
            return
          return
        delayLoading()
        $('.result-parking').css({display: 'block'})
        return
      error: (data) ->
        alertify.error("Failed !")
        return

    return

  return
