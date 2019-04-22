// $(document).on('click', 'ul.slot-list-items li a', function() {
//   if ($(this).hasClass('selected')) {
//     $(this).removeClass('selected');
//   } else {
//     $('ul.slot-list-items li a').each(function() {
//       $(this).removeClass('selected');
//     });
//     $(this).addClass('selected');
//   }
// });

$(document).on('ready', function() {
  var url = window.location.href;
  if (/#OK/.test(url)) {
    alertify.success('Thanh Cong !');
  }
});

(function($) {
  'use strict';
  return $('#sidebarToggle').on('click', function(e) {
    e.preventDefault();
    $('body').toggleClass('sidebar-toggled');
    $('.sidebar').toggleClass('toggled');
  });
})(jQuery);

function updateFloors(className) {
  $('.' + className).each(function(index) {
    $(this).find('legend.scheduler-border').html('Bãi ' + (index+1));
    $(this).find("input[name^='parking[floors_attributes]']").eq(0).val((index+1));
  });
}

function clearInputs(obj) {
  obj.find('input.form-control').each(function() {
    $(this).val('');
  });
}

function renameCloneIdsAndNames(objClone, name, number) {
  var new_id = (new Date).getTime();
  $(objClone).find("input[name^='"+name+"'], select[name^='"+name+"']").each(function() {
    if(number == 2) {
      var strNewId = $(this).attr('id').replace(/[0-9]+(?!.*[0-9])/, new_id);
      $(this).attr('id', strNewId);
      var strNewName = $(this).attr('name').replace(/[0-9]+(?!.*[0-9])/, new_id);
      $(this).attr('name', strNewName);
    } else {
      var strNewId = $(this).attr('id').replace(/\d+/, new_id);
      $(this).attr('id', strNewId);
      var strNewName = $(this).attr('name').replace(/\d+/, new_id);
      $(this).attr('name', strNewName);
    }
  });

  return objClone;
}

function delayLoading() {
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 1000);
}

$('input[type="checkbox"]').on('change', function() {
   $(this).siblings('input[type="checkbox"]').prop('checked', false);
});
