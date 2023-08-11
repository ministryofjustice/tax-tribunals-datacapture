'use strict';

moj.Modules.sendApplicationDetails = {
    selectors: {
        sendDetailsForm: '#new_steps_details_send_application_details_form',
        radioInput: 'input:radio',
        emailField: "#confirm-email",
        phoneField: "#confirm-phone"
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
        $(self.selectors.radioInput).on('change', (self.showConfirmations).bind(self));
    },

    showConfirmations: function(e) {
        const self = this,
              value = e.target.attributes.value.nodeValue;
        if (value == 'email' || value == 'both') {
            $(self.selectors.emailField).removeClass('hide');
        } else {
            $(self.selectors.emailField).addClass('hide');
        }
        if (value == 'text' || value == 'both') {
            $(self.selectors.phoneField).removeClass('hide');
        } else {
            $(self.selectors.phoneField).addClass('hide');
        }
    }
};
