'use strict';

moj.Modules.addressLookup = {
  // source: https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
  ukPostcodeRegEx: /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i,

  selectors: {
    formGroup: '.address-lookup',
    btn: '.address-lookup button',
    postcode: '#address_lookup',
    bearer: '#bearer',
    addressSearch: '.address-lookup',
    manualLink: '.address-lookup a',
    manualAddress: '#address-lookup-manual-address',
    addressOptions: '#address-lookup-addresses',
    addressOptionSelect: '#address-lookup-addresses select',
    addressLookupUrl: '#address_lookup_url',
    errorSpan: '#address-lookup-postcode-error',
    addressFields: ['.address', '.city', '.postcode', '.country'],
    addressesFound: '#addresses-found',
    noAddressFound: '#no-address-found'
  },

  classes: {
    inputError: 'govuk-input--error',
    formGroupError: 'govuk-form-group--error'
  },

  init: function() {
    const self = this;

    if($(self.selectors.btn).length) {
      $(self.selectors.manualAddress).addClass('hide');
      self.bindEvents();
    }
    else {
      $(self.selectors.addressSearch).hide();
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
    $(self.selectors.manualAddress).removeClass('hide');
  },

  govukErrorSummary: {
    selectors: {
      errorTemplate: '#address-lookup-error-summary',
      container: '.govuk-error-summary'
    },

    show : function() {
      const self = this,
            $tag = $(self.selectors.container + '.dynamic');
      if ($tag.length == 0) {
        $(
          $(self.selectors.errorTemplate).html()
        ).addClass('dynamic').insertBefore('form');
      }
    },

    hide: function() {
      const self = this;
      $(self.selectors.container + '.dynamic').remove();
    }
  },

  whenPostcodeValid: function(callback) {
    const self = this,
          $postcode = $(self.selectors.postcode),
          $formGroup = $(self.selectors.formGroup),
          $bearer = $(self.selectors.bearer),
          $url = $(self.selectors.addressLookupUrl);

    if (self.ukPostcodeRegEx.test($postcode.val())) {
      self.govukErrorSummary.hide();
      $formGroup.removeClass(self.classes.formGroupError);
      $formGroup.find(self.selectors.postcode).removeClass(self.classes.inputError);
      $(self.selectors.errorSpan).hide();
      callback($url.val(), $postcode.val(), $bearer.val());
    }
    else {
      self.govukErrorSummary.show();
      $formGroup.addClass(self.classes.formGroupError);
      $formGroup.find(self.selectors.postcode).addClass(self.classes.inputError);
      $(self.selectors.errorSpan).show();
    }
  },

  cache: {},

  postcodeLookup: function(e) {
    e.preventDefault();
    const self = this;

    self.whenPostcodeValid((function(url, postcode, token) {
      const self = this;

      $.ajax({
        beforeSend: function(jq, settings) {
          const cache = moj.Modules.addressLookup.cache;

          if (cache[postcode] !=  null) {
            moj.Modules.addressLookup.renderAddressOptions(cache[postcode]);
            return false;
          }
          else {
            return true;
          }
        },
        url: url,
        method: 'GET',
        cache: true,
        data: { "postcode": postcode },
        headers: { "Authorization": "Bearer " + token },
        success: (self.renderAddressOptions).bind(self),
        error: (self.handleError).bind(self),
        complete: function(jq, status) {
          if (status == 'success') {
            moj.Modules.addressLookup.cache[postcode] = jq.responseJSON;
          }
        }
      });
    }).bind(self));
  },

  formatOptions: function(entry, idx) {
    const self = this,
          inline = function (a) {
            return moj.Modules.addressLookup.dpaFormatters.helpers.toString(a, ', ');
          },
          dpa = self.dpaValueGetter(entry, {address: inline});
    return '<option value="' + idx +'">' + [dpa.address, dpa.city, dpa.postcode].join(', ') + '</option>';
  },

  renderAddressOptions: function(data) {
    const self = this,
          $addressBox = $(self.selectors.addressOptions),
          $formGroup = $(self.selectors.formGroup),
          adrFound = $(self.selectors.addressesFound).text(),
          noAdrFound = $(self.selectors.noAddressFound).text();

    self.addresses = data.results;

    if (self.addresses) {
      var options = $.map(self.addresses, (self.formatOptions).bind(self));
      options.unshift('<option>' + options.length + ' ' + adrFound + '</option>');
      $addressBox.find('p').hide();
      $addressBox.find('select').html(options).show();
      $addressBox.show();
    }
    else {
      $addressBox.find('select').hide();
      $addressBox.find('p').html(noAdrFound).show();
      $addressBox.show();
      $formGroup.addClass(self.classes.formGroupError);
      $formGroup.find(self.selectors.postcode).addClass(self.classes.inputError);
    }
  },

  dpaValueGetter: function(entry, formatOptions) {
    var self = this,
        dpa;
    if (entry == null || entry === 'undefined') {
      dpa = {};
    }
    else {
      dpa = entry['DPA'] || {};
      const adrNames = ['SUB_BUILDING_NAME','BUILDING_NAME','BUILDING_NUMBER','DEPENDENT_THOROUGHFARE_NAME','THOROUGHFARE_NAME','DOUBLE_DEPENDENT_LOCALITY','DEPENDENT_LOCALITY', 'POST_TOWN']
      for (const key in dpa) {
        if (adrNames.includes(key)) {
          dpa[key] = dpa[key].toLowerCase().replace(/\b[a-z]/g, function(letter) {
            return letter.toUpperCase(); } );
        }
      }
    }

    const addressFormat = formatOptions.address;
    return {
      address: addressFormat(
        [
          dpa.SUB_BUILDING_NAME,
          dpa.BUILDING_NAME,
          dpa.BUILDING_NUMBER,
          dpa.DEPENDENT_THOROUGHFARE_NAME,
          dpa.THOROUGHFARE_NAME,
          dpa.DOUBLE_DEPENDENT_LOCALITY,
          dpa.DEPENDENT_LOCALITY
        ]),
      postcode: dpa.POSTCODE,
      city: dpa.POST_TOWN,
      country: 'United Kingdom'
    };
  },

  dpaFormatters: {
    helpers: {
      toString: function (a, sep) {
        return a.filter(function(e) {
          return e != null && e != 'undefined' && e != '';
        }).join(sep);
      }
    }
  },

  fillAddressFields: function(e) {
    e.preventDefault();
    const self = this,
          idx = $(e.currentTarget).val(),
          $manualAddress = $(self.selectors.manualAddress),
          lineBreak = function (a) {
            return moj.Modules.addressLookup.dpaFormatters.helpers.toString(a, ',\n');
          };

    const dpa = self.dpaValueGetter(self.addresses[idx], {address: lineBreak});

    $.each(self.selectors.addressFields, function(_, fieldSelector) {
      const key = fieldSelector.replace('.', '');
      $manualAddress.find(fieldSelector).val(dpa[key]);
    });
    $manualAddress.removeClass('hide');
  },

  handleError: function(e) {
    const self = this,
          $addressBox = $(self.selectors.addressOptions);

    $addressBox.find('select').hide();
    $addressBox.find('p').show();
    $addressBox.addClass(self.classes.formGroupError);
    $addressBox.show();
    $(self.selectors.manualLink).trigger('click');
  }
};
