'use strict';

moj.Modules.hearingSupport = {
    selectors: {
        language: '#steps-details-what-support-form-language-interpreter-details-field',
        signLanguage: '#steps-details-what-support-form-sign-language-interpreter-details-field'
    },

    init: function() {
        const self = this;
        if ($(self.selectors.language).length) {
            self.bindEvents();
        }
    },

    conf: {
        width: 'element',
        theme: 'govuk'
    },

    bindEvents: function() {
        const self = this;
        $(self.selectors.language).select2(self.conf);
        $(self.selectors.signLanguage).select2(self.conf);
    }
}
