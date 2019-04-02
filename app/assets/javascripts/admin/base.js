(function($) {
  'use strict';
  return $('#sidebarToggle').on('click', function(e) {
    e.preventDefault();
    $('body').toggleClass('sidebar-toggled');
    $('.sidebar').toggleClass('toggled');
  });
})(jQuery);

// $('#dataTable').DataTable({
//    ajax: {
//        url: '/admin/managers/get_manager_list.json',
//        dataSrc: 'managers'
//    },
//    serverSide: true,
//    columns: [
//        { title: 'ID', data: 'id' },
//        { title: 'Email', data: 'email' }
//    ]
// });
