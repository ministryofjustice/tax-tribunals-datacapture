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
        selectOnClose: true,
        language: {
            noResults: function() {
                return $('.select2-no-results').text();
            }
        }
    },

    dropdownAdapter: async function() {
            return new Promise(function(resolve, reject) {
                $.fn.select2.amd.require(
                    ['select2/utils',
                     'select2/dropdown',
                     'select2/dropdown/search',
                     'select2/dropdown/attachBody'],
                    function (Utils, Dropdown, Search, AttachBody) {
                        function PositionDropdown() {}
                        PositionDropdown.prototype._positionDropdown = function (decorated) {
                            decorated.call(this);
                            var a = this.$dropdownContainer.offset();
                            this.$dropdownContainer.css({
                                top: a.top - 18,
                                left: a.left - 5
                            });
                        };

                        var DropdownSearch = Utils.Decorate(Dropdown, Search);
                        var AttachedDropdownSearch = Utils.Decorate(DropdownSearch, AttachBody);
                        return resolve(Utils.Decorate(AttachedDropdownSearch, PositionDropdown));
                    }
                );
            });
    },

    bindEvents: async function() {
        const self = this;
        let conf = self.conf;

        conf.dropdownAdapter = await self.dropdownAdapter();

        $(self.selectors.select).select2(self.conf);
    }
}
