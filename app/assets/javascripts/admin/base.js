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
    $(this).find('legend.scheduler-border').html('Tầng ' + (index+1));
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

function loadingOverlay() {
  $.LoadingOverlay("show");
  setTimeout((function() {
    $.LoadingOverlay('hide');
  }), 2000);
}
