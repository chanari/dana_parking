$(document).on('click', 'ul.slot-list-items li a', function() {
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#price-hours').val('');
    $('.result-parking').find('input.vitri').val('');
  } else {
    $('ul.slot-list-items li a').each(function() {
      $(this).removeClass('selected');
    });
    $(this).addClass('selected');
    $('#price-hours').val((($(this).attr('data-p-hours').split(".")[0])/1000).toFixed(3) + ' VND');
    $('.result-parking').find('input.vitri').val($(this).text());
  }
});

function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}
