'use strict';

moj.Modules.addressLookup = {
    // source: https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
    ukPostcodeRegEx: /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i,

    selectors: {
        btn: '.address-lookup button',
        postcode: '#address_lookup',
        bearer: '#bearer',
        manualLink: '.address-lookup a',
        manualAddress: '#address-lookup-manual-address',
        addressOptions: '#address-lookup-addresses',
        addressOptionSelect: '#address-lookup-addresses select',
        addressLookupUrl: '#address_lookup_url',
        addressFields: ['.address', '.city', '.postcode', '.country']
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
        $(self.selectors.addressOptionSelect).on("change", (self.fillAddressFields).bind(self));
    },

    showAddressFields: function(e) {
        const self = this;

        $(self.selectors.manualLink).hide();
        $(self.selectors.manualAddress).show();
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

    formatOptions: function(entry, idx) {
        const self = this;
        const dpa = self.dpaValueGetter(entry);
        return '<option value="' + idx +'">' + [dpa.address, dpa.city, dpa.postcode].join(', ') + '</option>';
    },

    renderAddressOptions: function(data) {
        const self = this,
              $addressBox = $(self.selectors.addressOptions);

        self.addresses = data.results;

        if (self.addresses.length > 0) {
            var options = $.map(self.addresses, (self.formatOptions).bind(self));
            options.unshift('<option>' + options.length + ' addresses found' + '</option>');
            $addressBox.find('p').hide();
            $addressBox.find('select').html(options).show();
            $addressBox.show();
        }
        else {
            $addressBox.find('select').hide();
            $addressBox.find('p').html('No address found').show();
            $addressBox.show();
      }
    },

    dpaValueGetter: function(entry) {
        var dpa;
        if (entry == null || entry === 'undefined') {
            dpa = {};
        }
        else {
            dpa = entry['DPA'] || {};
        }
        return {
            address: [
                dpa.BUILDING_NAME,
                dpa.BUILDING_NUMBER,
                dpa.THOROUGHFARE_NAME
            ].filter(function(e) { return e != null || e != 'undefined'; }).join(' '),
            postcode: dpa.POSTCODE,
            city: dpa.POST_TOWN,
            country: 'United Kingdom'
        };
    },

    fillAddressFields: function(e) {
        e.preventDefault();
        const self = this,
              idx = $(e.currentTarget).val(),
              $manualAddress = $(self.selectors.manualAddress);

        const dpa = self.dpaValueGetter(self.addresses[idx]);

        $.each(self.selectors.addressFields, function(_, fieldSelector) {
            const key = fieldSelector.replace('.', '');
            $manualAddress.find(fieldSelector).val(dpa[key]);
        });
        $manualAddress.show();
    },

    handleError: function(e) {
        const self = this,
              $addressBox = $(self.selectors.addressOptions);

        $addressBox.find('select').hide();
        $addressBox.find('p').html('An error occurred, Please enter the address manually').show();
        $addressBox.show();
        $(self.selectors.manualLink).trigger('click');
    }
};
