(($) ->
  'use strict'
  
  $('#sidebarToggle').on 'click', (e) ->
    e.preventDefault()
    $('body').toggleClass 'sidebar-toggled'
    $('.sidebar').toggleClass 'toggled'
    return

) jQuery
