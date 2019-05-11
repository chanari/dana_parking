$('#managerParking').on 'show.bs.modal', (e) ->
  $trigger = $(e.relatedTarget)
  id = $trigger.data('mid')
  $('#user_id').val(id)
  return

$(document).ready ->

  $('.btn-change').click (e) ->
    e.preventDefault()
    $('.admin_profile .form-control').each ->
      $(this).removeAttr('readonly')
      return
    $(this).closest('div').toggle 500
    $('#div-update').toggle 500
    return

  $('.btn-cancel').click (e) ->
    e.preventDefault()
    $('.admin_profile .form-control').each ->
      $(this).attr('readonly', 'readonly')
      return
    $(this).closest('div').toggle 500
    $('#div-change').toggle 500
    return

  $('#btn-modal-luu').click ->
    parking_id = $('#parking').val()
    user_id = $('#user_id').val()
    if user_id < 0 || parking_id == ''
      alertify.message('Select Something')
      return
    $.ajax
      url: '/admin/managers/update_parking'
      type: 'GET'
      dataType: 'JSON'
      data:
        parking_id: parking_id
        user_id: user_id
      success: (data) ->
        window.location = window.location.href + "#OK"
        window.location.reload()
        return
      error: (data) ->
        alertify.error('Failed !!!')
        return
    return

  $('#rm-parking').click ->
    user_id = $(this).data('mid')
    if confirm('Ban co chac chan muon xoa?')
      $.ajax
        url: '/admin/managers/remove_parking'
        type: 'GET'
        dataType: 'JSON'
        data:
          user_id: user_id
        success: (data) ->
          window.location = window.location.href + "#OK"
          window.location.reload()
          return
        error: (data) ->
          alertify.error('Failed !!!')
          return
    return

  $('.btn-user').click ->
    user_id = $(this).data('uid')
    return false unless user_id > 0
    $.ajax
      url: '/admin/managers/get_profile'
      type: 'GET'
      dataType: 'JSON'
      data: user_id: user_id
      success: (data) ->
        $('#fullHeightModalRight').find('.modal-body .col-md-7').eq(0).html(data.month + ' VND')
        $('#fullHeightModalRight').find('.modal-body .col-md-7').eq(1).html(data.total + ' VND')
        $('#fullHeightModalRight').modal('show')
        return
      error: ->
        alertify.error('Thất bại !')
        return
    return

  $('#modalResetPassword').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    manager_id = button.data('mid')
    $('#form-reset').find('input').eq(0).val(manager_id)
    return

  $('#btn-resetp').click ->
    dataform = $("#form-reset").serialize()
    $.ajax
      url: '/admin/managers/manager_reset_password'
      type: 'PUT'
      dataType: 'JSON'
      data: dataform
      success: (data) ->
        alertify.success("Thành công.")
        return
      error: ->
        alertify.error('Thất bại !')
        return
    $('#modalResetPassword').modal('hide')
    return

  $('input[type=file]').change (e) ->
    $(this).next('label').html e.target.files[0].name
    return
  return
