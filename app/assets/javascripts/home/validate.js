$(document).ready(function (){
  if($('#new_helper').length > 0) {
    $('#new_helper').validate({
      rules: {
        "helper[name]": {
          required: true
        },
        "helper[email]": {
          required: true,
          email: true
        },
        "helper[phone]": {
          required: true,
          minlength: 10,
          maxlength: 10
        },
        "helper[content]": {
          required: true
        }
      },
      messages: {
        "helper[name]": {
          required: " Bạn chưa nhập tên."
        },
        "helper[email]": {
          required: "Bạn chưa nhập email.",
          email: "Vui lòng nhập email."
        },
        "helper[phone]": {
          required: "Bạn chưa nhập SDT.",
          minlength: "Vui lòng nhập 1 SDT.",
          maxlength: "Vui lòng nhập 1 SDT."
        },
        "helper[content]": {
          required: "Bạn chưa nhập tin nhắn."
        }
      }
    });
  }
});
