$(document).ready(function() {
  if ($('#change_profile').length > 0) {
    $('#change_profile').validate({
      rules: {
        'profile[first_name]': {
          required: true
        },
        'profile[last_name]': {
          required: true
        },
        'profile[phone]': {
          required: true,
          minlength: 14,
          maxlength: 14
        },
        'profile[address]': {
          required: true
        }
      },
      messages: {
        'profile[first_name]': {
          required: 'Bạn chưa nhập họ.'
        },
        'profile[last_name]': {
          required: 'Bạn chưa nhập tên.'
        },
        'profile[phone]': {
          required: 'Bạn chưa nhập SDT.',
          minlength: "Vui lòng nhập 1 SDT.",
          maxlength: "Vui lòng nhập 1 SDT."
        },
        'profile[address]': {
          required: 'Bạn chưa nhập địa chỉ.'
        }
      }
    });
  }
  if ($('#change_password').length > 0) {
    $('#change_password').validate({
      rules: {
        'user[current_password]': {
          required: true,
          minlength: 6
        },
        'user[password]': {
          required: true,
          minlength: 6
        },
        'user[password_confirmation]': {
          required: true,
          minlength: 6,
          equalTo: "#user_password"
        }
      },
      messages: {
        'user[current_password]': {
          required: 'Bạn chưa nhập mật khẩu',
          minlength: 'Mật khẩu tối thiểu 6 ký tự.'
        },
        'user[password]': {
          required: 'Bạn chưa nhập mật khẩu',
          minlength: 'Mật khẩu tối thiểu 6 ký tự.'
        },
        'user[password_confirmation]': {
          required: 'Bạn chưa nhập mật khẩu',
          minlength: 'Mật khẩu tối thiểu 6 ký tự.',
          equalTo: 'Mật khẩu không khớp.'
        }
      }
    });
  }
  if ($('#new_vehicle').length > 0) {
    $('#new_vehicle').validate({
      rules: {
        'vehicle[number_plate]': {
          required: true,
          minlength: 10
        },
        'vehicle[vehicle_name]': {
          required: true
        }
      },
      messages: {
        'vehicle[number_plate]': {
          required: 'Bạn chưa nhập thông tin này.',
          minlength: 'Xin nhập 1 BKS.'
        },
        'vehicle[vehicle_name]': {
          required: 'Bạn chưa nhập thông tin này.'
        }
      }
    });
  }
});
