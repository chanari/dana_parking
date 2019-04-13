// $('ul.slot-list-items li').on('click', 'a', function() {
//   if ($(this).hasClass('selected')) {
//     $(this).removeClass('selected');
//   } else {
//     $('ul.slot-list-items li a').each(function() {
//       $(this).removeClass('selected');
//     });
//     $(this).addClass('selected');
//   }
// });

$(document).ready(function() {
  // let parks = ['','Nguyễn Văn Linh', 'Hàm Nghi'];
  // $('.baixe').val(parks[parseInt(this.value)]);
  // Select slot
  // let selectedSlot = [];

  // $('select#selectPark').on('change', function() {
  //   if (this.value !== '') {
  //     $('.result-parking').css({display: 'block'})
  //   } else {
  //     $('.result-parking').css({display: 'none'})
  //   }
  //   $('.baixe').val(parks[parseInt(this.value)]);
  // });

  $('form').on('change', function() {
    if ($('input[name=inlineRadioOptions]:checked', 'form').val() === 'month') {
      $('.select-month').css({display: "block"});
      $('.select-day').css({display: "none"});
    } else {
      $('.select-month').css({display: "none"});
      $('.select-day').css({display: "block"});
    }
  });

})
