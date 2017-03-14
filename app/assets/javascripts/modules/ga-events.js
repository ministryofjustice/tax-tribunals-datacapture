'use strict';

moj.Modules.gaEvents = {
  radioFormClass: '.ga-radioButtonGroup',
  checkboxClass: '.ga-checkbox',
  linkClass: '.ga-pageLink',
  fileUploadFormClass: '.ga-fileUpload',

  init: function() {
    var self = this;

    if($(self.radioFormClass).length) {
      self.trackRadioForms();
    }
    if($(self.checkboxClass).length) {
      self.trackCheckboxes();
    }
    if($(self.linkClass).length) {
      self.trackLinks();
    }
    if($(self.fileUploadFormClass).length) {
      self.trackFileUploads();
    }
  },

  trackRadioForms: function() {
    var self = this,
        $form = $(self.radioFormClass);

    $form.on('submit', function(e) {
      e.preventDefault();

      self.getRadioChoiceData($form);
    });
  },

  trackCheckboxes: function() {
    var self = this,
        $checkboxes = $(self.checkboxClass);

    $checkboxes.each(function(n, $checkbox) {
      var $form = $($checkbox.closest('form'));

      $form.on('submit', function(e) {
        e.preventDefault();

        if($form.find(self.checkboxClass + ':checked').length) {
          self.getCheckboxData($form);
        } else {
          $form.unbind('submit').trigger('submit');
        }
      });
    });
  },

  trackLinks: function() {
    var self = this,
        $links = $(self.linkClass);

    $links.on('click', function(e) {
      e.preventDefault();
      self.getLinkData($(e.target));
    });
  },

  trackFileUploads: function() {
    var self = this,
        $fileEls = $(self.fileUploadFormClass).find('[type="file"]');

    $fileEls.on('click', function(e) {
      self.getFileUploadData($(e.target));
    });
  },

  getLinkData: function($link) {
    var self = this,
        eventData,
        options;

    eventData = {
      eventCategory: $link.data('ga-category'),
      eventAction: 'select_link',
      eventLabel: $link.data('ga-label')
    };

    options = {
      hitCallback: self.createFunctionWithTimeout(function() {
        document.location = $link.attr('href');
      })
    };

    self.sendAnalyticsEvent(eventData, options);
  },

  getRadioChoiceData: function($form) {
    var self = this,
        $selectedRadio = $form.find('input[type="radio"]:checked'),
        stepName = $selectedRadio.attr('name'),
        selectedValue = $selectedRadio.val(),
        eventData,
        options;

    eventData = {
      eventCategory: stepName,
      eventAction: 'choose',
      eventLabel: selectedValue
    };

    options = {
      hitCallback: self.createFunctionWithTimeout(function() {
        $form.unbind('submit').trigger('submit');
      })
    };

    self.sendAnalyticsEvent(eventData, options);
  },

  getCheckboxData: function($form) {
    var self = this,
        checkedCheckboxes = $form.find(self.checkboxClass + ':checked');

    checkedCheckboxes.each(function(n, checkbox) {
      var $checkbox = $(checkbox),
          eventData;

      eventData = {
        hitType: 'event',
        eventCategory: $checkbox.attr('name'),
        eventAction: 'checkbox',
        eventLabel: $checkbox.data('ga-label')
      };

      ga('send', eventData);
    });

    self.createFunctionWithTimeout(function() {
      $form.unbind('submit').trigger('submit');
    });
  },

  getFileUploadData: function($el) {
    var self = this,
        $form = $el.closest('form'),
        eventData;

    eventData = {
      eventCategory: $form.data('ga-category'),
      eventAction: 'upload',
      eventLabel: $form.data('ga-label')
    };

    self.sendAnalyticsEvent(eventData);
  },

  sendAnalyticsEvent: function(eventData, opts) {
    var opts = opts || {};

    eventData.hitType = 'event';
    ga('send', eventData, opts);
  },

  createFunctionWithTimeout: function(callback, opt_timeout) {
    // https://developers.google.com/analytics/devguides/collection/analyticsjs/sending-hits
    var called = false;
    function fn() {
      if (!called) {
        called = true;
        callback();
      }
    }
    setTimeout(fn, opt_timeout || 1000);
    return fn;
  }
};
