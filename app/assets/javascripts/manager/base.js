$(document).on('click', 'ul.slot-list-items li a', function() {
  if ($(this).hasClass('selected')) {
    $(this).removeClass('selected');
    $('#form-detail').find('input.vitri').val('');
    $('#form-detail').find('.options').css('display','none');
    $('#price-month').val('');
    $('#price-hours').val('');
  } else {
    $('ul.slot-list-items li a').each(function() {
      $(this).removeClass('selected');
    });
    $(this).addClass('selected');
    $('#form-detail').find('input.vitri').val($(this).text());
    $('#form-detail').find('.options').removeAttr('style');
    $('#price-month').val($(this).attr('data-p-hours').split(".")[0] + ' VND');
    $('#price-hours').val($(this).attr('data-p-months').split(".")[0] + ' VND');
  }
});

function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}
