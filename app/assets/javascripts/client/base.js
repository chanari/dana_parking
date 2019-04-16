$(document).on('click', 'ul.slot-list-items li a', function() {
  $('#slot-id').val('');
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#price-hours').val('');
    $('.result-parking').find('input.vitri').val('');
  } else {
    $('ul.slot-list-items li a').each(function() {
      $(this).removeClass('selected');
    });
    $(this).addClass('selected');
    $('#slot-id').val($(this).attr('id').match(/\d+/));
    $('#price-hours').val((($(this).attr('data-p-hours').split(".")[0])/1000).toFixed(3) + ' VND');
    $('.result-parking').find('input.vitri').val($(this).text());
  }
});

function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}

$(document).ready(function(){
  $('.bks').mask('00Z-000.00', {
    translation: {
      'Z': {
        pattern: /[a-z]/
      }
    }
  });
});