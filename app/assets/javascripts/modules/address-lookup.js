'use strict';

moj.Modules.addressLookup = {
    // source: https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
    ukPostcodeRegEx: /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i,

    selectors: {
        btn: '.address-lookup button',
        postcode: '#address_lookup',
        bearer: '#bearer',
        manualLink: '.address-lookup a',
        addressFields: '#address-lookup-manual-address',
        addressOptions: '#address-lookup-addresses',
        addressLookupUrl: '#address_lookup_url'
    },

    classes: {
        inputError: 'govuk-form-group--error'
    },

    init: function() {
        const self = this;

        if($(self.selectors.btn).length) {
            self.bindEvents();
        }
    },

    bindEvents: function() {
        const self = this;

        $(self.selectors.btn).on("click", (self.postcodeLookup).bind(self));
        $(self.selectors.manualLink).on("click", (self.showAddressFields).bind(self));
        $(self.selectors.addressOptions).on("click", (self.fillAddressFields).bind(self));
    },

    showAddressFields: function(e) {
        const self = this;

        $(self.selectors.manualLink).hide();
        $(self.selectors.addressFields).show();
    },

    whenValidPostcode: function(callback) {
        const self = this,
              $postcode = $(self.selectors.postcode);

        if (self.ukPostcodeRegEx.test($postcode.val())) {
            callback($postcode.val());
        }
        else {
            console.log('invalid postcode')
            // insert error message
            //  <span class="govuk-error-message" id="address-lookup-postcode-error">
            //    <span class="govuk-visually-hidden">Error: </span>
            // Please enter a name</span>
        }
    },

    postcodeLookup: function(e) {
        e.preventDefault();
        const self = this;

        self.whenValidPostcode((function(postcode) {
            const self = this,
                  $bearer = $(self.selectors.bearer),
                  $url = $(self.selectors.addressLookupUrl);

            $.ajax({
                url: $url.val(),
                method: 'GET',
                data: { "postcode": postcode },
                headers: { "Authorization": "Bearer " + $bearer.val() },
                success: (self.renderAddressOptions).bind(self),
                error: (self.handleError).bind(self),
                xhrFields: {
                    withCredentials: true
                }
            });
        }).bind(self));
    },

    renderAddressOptions: function(e) {
        console.log('render options')
        // count result
        // if at least 1
        // format select options
        // insert options
        // display select box
        // else -> enter manually
    },

    fillAddressFields: function(e) {
        var self = this;
        e.preventDefault();
        console.log('filladrressfields');
    },

    handleError: function(e) {
        console.log('error')
    }
};
