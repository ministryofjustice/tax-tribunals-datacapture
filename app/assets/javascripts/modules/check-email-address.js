'use strict';

moj.Modules.checkEmail = {
  container: 'verify-password-form',
  input_id: 'user_email',
  confirmation_panel_class: 'email-confirmation',

  init: function() {
    var self = this,
        $emailField = $('.' + self.container).find('#' + self.input_id);

    if($emailField.length) {
      self.$emailField = $emailField;
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this;

    self.$emailField.on('keyup change focus blur', function() {
      self.checkValue();
    });
  },

  checkValue: function() {
    var self = this,
        val = self.$emailField.val(),
        length = val.length;

    if(length) {
      self.showConfirmation(val);
    } else {
      self.hideConfirmation();
    }
  },

  showConfirmation: function(val) {
    var self = this;

    if(!$('.' + self.confirmation_panel_class).length) {
      self.createConfirmationPanel();
    }
    $('.' + self.confirmation_panel_class).removeClass('js-hidden');
    $('.' + self.confirmation_panel_class).find('strong').text(val);
    self.$emailField.closest('.form-group').addClass('tight');
  },

  createConfirmationPanel: function() {
    var self = this;

    self.$emailField.closest('.form-group').after('<div class="panel ' + self.confirmation_panel_class + '"><p class="form-hint">' + moj.Modules.emailConfirmationText + '</p><strong></strong></div>');
  },

  hideConfirmation: function() {
    var self = this;

    self.$emailField.closest('.form-group').removeClass('tight');
    $('.' + self.confirmation_panel_class).addClass('js-hidden');
  }
};
