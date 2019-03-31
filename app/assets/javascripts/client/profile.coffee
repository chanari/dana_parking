$(document).ready ->

  $('.btn-change').click (e) ->
    e.preventDefault()
    $('.edit_profile .form-control').each ->
      $(this).removeAttr('readonly')
      return
    $(this).closest('div').toggle 500
    $('#div-update').toggle 500
    return

  $('.btn-cancel').click (e) ->
    e.preventDefault()
    $('.edit_profile .form-control').each ->
      $(this).attr('readonly', 'readonly')
      return
    $(this).closest('div').toggle 500
    $('#div-change').toggle 500
    return
  return
