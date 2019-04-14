$(document).on('click', 'ul.slot-list-items li a', function() {
  $('#slot-id').val('');
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#form-detail').find('input.vitri').val('');
    $('#form-detail').find('.options').css('display','none');
    $('#price-month').val('');
    $('#price-hours').val('');
  }
  else if ($(this).hasClass('selecting')) {
    $('#slot-detail').modal('show');
  }
  else if ($(this).hasClass('reservation')) {
    $('#slot-reserve').modal('show');
  }
  else {
    $('ul.slot-list-items li a').each(function() {
      $(this).removeClass('selected');
    });
    $(this).addClass('selected');
    $('#form-detail').find('input.vitri').val($(this).text());
    $('#form-detail').find('.options').removeAttr('style');
    $('#price-month').val((($(this).attr('data-p-months').split(".")[0])/1000).toFixed(3) + ' VND');
    $('#price-hours').val((($(this).attr('data-p-hours').split(".")[0])/1000).toFixed(3) + ' VND');
    $('#slot-id').val($(this).attr('id').match(/\d+/));
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
        pattern: /[a-z]/, optional: true
      }
    }
  });
});
