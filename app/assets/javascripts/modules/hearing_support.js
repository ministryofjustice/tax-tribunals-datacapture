'use strict';

moj.Modules.hearingSupport = {
    selectors: {
        select: '.select2',
    },

    init: function() {
        const self = this;
        if ($(self.selectors.select).length) {
            self.bindEvents();
        }
    },

    conf: {
        width: 'element',
        theme: 'govuk'
    },

    bindEvents: function() {
        const self = this;
        $(self.selectors.select).select2(self.conf);
    }
}
