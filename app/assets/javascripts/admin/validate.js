$(document).ready(function() {
  $('#new_user').validate({
    rules: {
      'user[email]': {
        required: true
      },
      'profile[first_name]': {

      },
      'profile[last_name]': {

      },
      'profile[phone]': {

      },
      'profile[address]': {
        
      }
    },
    messages: {

    }
  });
});
