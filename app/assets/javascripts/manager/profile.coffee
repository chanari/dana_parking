$(document).ready ->

  $('#a-profile').click ->
    if $(this).hasClass('active')
      return
    $(this).addClass('active')
    $('#tab-password').css('display', 'none')
    $('#a-password').removeClass('active')
    $('#tab-profile').css('display', 'block')
    return

  $('#a-password').click ->
    if $(this).hasClass('active')
      return
    $(this).addClass('active')
    $('#tab-profile').css('display', 'none')
    $('#a-profile').removeClass('active')
    $('#tab-password').css('display', 'block')
    return
  return
