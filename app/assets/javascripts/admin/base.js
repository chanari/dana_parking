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
    // $("input[name^='parking[floors_attributes]']").each(function() {
    //   var strNewId = $(this).attr('id').replace(/\d+$/, function(strId) { return (new Date).getTime(); });
    //   return $(this).attr('id',strNewId);
    // });
  });
}

function clearInputs(obj) {
  obj.find('input.form-control').each(function() {
    $(this).val('');
  });
}

function demoLoadingOverlay() {
  $.LoadingOverlay("show");
  setTimeout(function(){
    $.LoadingOverlay("hide");
  }, 2000);
}
