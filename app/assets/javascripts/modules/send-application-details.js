'use strict';

moj.Modules.sendApplicationDetails = {
    selectors: {
        sendDetailsForm: '#new_steps_details_send_application_details_form',
        radioInput: 'input:radio',
        emailField: "#confirm-email"
    },

    emailFieldTemplate: "",

    init: function() {
        const self = this;
        if ($(self.selectors.sendDetailsForm).length) {
            self.bindEvents();
        }
    },

    bindEvents: function() {
        const self = this;
        $(self.selectors.radioInput).on('change', (self.confirmEmail).bind(self));
    },

    confirmEmail: function(e) {
        const self = this,
              value = e.target.attributes.value.nodeValue;
        if (value == 'yes') {
            $(self.selectors.emailField).removeClass('hide');
        }
        else {
            $(self.selectors.emailField).addClass('hide');
        }
    }
};
