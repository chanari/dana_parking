$(document).on('click', 'ul.slot-list-items li a', function() {
  $('#slot-id').val('');
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#form-detail').find('input.vitri').val('');
    $('#form-detail').find('.options').css('display','none');
    $('#price-month').val('');
    $('#price-hours').val('');
  }
  else if ($(this).hasClass('selecting') || $(this).hasClass('reservation')) {
    removeSelected();
    $('#form-detail').trigger("reset");
    $('#form-detail').find('.options').css('display', 'none');
    $('#slot-id').val($(this).attr('id').match(/\d+/));
    return;
  }
  else {
    removeSelected()
    $(this).addClass('selected');
    $('#form-detail').find('input.vitri').val($(this).text());
    $('#form-detail').find('.options').css('display', '');
    $('#price-month').val((($(this).attr('data-p-months').split(".")[0])/1000).toFixed(3));
    $('#price-hours').val((($(this).attr('data-p-hours').split(".")[0])/1000).toFixed(3));
    $('#slot-id').val($(this).attr('id').match(/\d+/));
  }
});

$('#quantity').bind('keyup mouseup', function() {
  var count = $(this).val();
  var slot_id = $('#slot-id').val();
  var price = $('#slot-'+slot_id).attr('data-p-months').split(".")[0] * count
  $('#price-month').val((price/1000).toFixed(3));
});

function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}

function dateFormat(string) {
  return string.split('.')[0].replace('T', ' ')
}

function removeSelected(){
  $('ul.slot-list-items li a').each(function() {
    $(this).removeClass('selected');
  });
}

function monthFormat(string) {
  return string.split('T')[0]
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
