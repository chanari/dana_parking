$(document).on('click', 'ul.slot-list-items li a', function() {
  $('#slot-id').val('');
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#client-booking').trigger('reset');
    if ($('#selectPark').val() === 0) {
      $('.result-parking').find('input.baixe').val('');
    } else {
      $('.result-parking').find('input.baixe').val($('#selectPark').find('option:selected').text());
    }
  } else if ($(this).hasClass('reservation')) {
    var slot_id = $(this).attr('id').split('-')[1];
    $('#slot-id-modal').val(slot_id);
    $.ajax({
      url: '/client/booking/get_slot_detail',
      type: 'GET',
      dataType: 'JSON',
      data: { slot_id: slot_id },
      success: function(data) {
        $('#slot-expired-modal').html(data.slot_expired);
      },
      error: function() {
        alertify.error('Thất bại !');
      }
    });
    $('#slot-modal').modal('show');
  } else if ($(this).hasClass('selecting')) {
    return;
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
