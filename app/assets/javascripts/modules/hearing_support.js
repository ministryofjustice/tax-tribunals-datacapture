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
        theme: 'govuk',
        language: {
            noResults: function() {
                return $('.select2-no-results').text();
            }
        },
        // selectionAdapter: function() {
        //     console.log('this is callled!!!!!!!!')
        // }
    },

    bindEvents: function() {
        const self = this;
        $(self.selectors.select).select2(self.conf);
    }
}
