//= require action_cable
//= require_self
//= require channels/booking

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

}).call(this);
