function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}

$('#selectPark').change(function() {
  $('#selectSlot').val('0');
  $('.result-parking').css('display', 'none');
});

$('#selectSlot').change(function() {
  var block_size, n, park_id;
  n = 0;
  park_id = $('#selectPark').val();
  block_size = $('#selectSlot').val();
  if (park_id === '0' || block_size === '0') {
    $('.result-parking').css({
      display: 'none'
    });
    return;
  }
  $.LoadingOverlay('show');
  $.ajax({
    url: '/home/floors',
    type: 'GET',
    dataType: 'JSON',
    data: {
      park_id: park_id,
      block_size: block_size
    },
    success: function(data) {
      $('#resultTab').find('li').not(':first').remove();
      $('#resultTabContent').find('.tab-pane').not(':first').remove();
      if (data.length == 0) {
        $('.result-parking').css('display', 'none');
        alertify.error("Chưa có bãi với loại xe này");
        $.LoadingOverlay('hide');
        return;
      }
      $.each(data, function(i, floor) {
        $.each(floor.blocks, function(ii, blocks) {
          var nav_tab, result_tab;
          nav_tab = $('#resultTab').find('.nav-item').eq(0).clone();
          nav_tab.removeAttr('style');
          nav_tab.find('a').attr('href', '#block' + blocks.id);
          nav_tab.find('a').attr('aria-controls', blocks.id);
          if (n === 0) {
            nav_tab.find('a').attr('aria-selected', 'true');
            nav_tab.find('a').addClass('active');
            n = n + 1;
          }
          nav_tab.find('a').html(blocks.name);
          $('#resultTab').append(nav_tab);
          result_tab = $('#resultTabContent').find('.tab-pane').eq(0).clone();
          result_tab.removeAttr('style');
          result_tab.attr('id', 'block' + blocks.id);
          result_tab.attr('aria-labelledby', blocks.id + '-tab');
          if (n === 1) {
            result_tab.addClass('active');
            n = n + 1;
          }
          $.each(blocks.parking_slots, function(iii, slots) {
            switch (slots.status) {
              case '0':
                slots.status = '';
                break;
              case '1':
                slots.status = 'reservation';
                break;
              case '2':
                slots.status = 'selecting';
                break;
            }
            result_tab.find('.slot-list-items').append('<li class="col-2 slot-item"> <a id="slot-' + slots.id + '" class="' + slots.status + '" href="javascript:void(0)">' + slots.name + '</a></li>');
          });
          $('#resultTabContent').append(result_tab);
        });
      });
      delayLoading();
      $('.result-parking').css({
        display: 'block'
      });
    },
    error: function(data) {
      alertify.error("Failed !");
    }
  });
});
