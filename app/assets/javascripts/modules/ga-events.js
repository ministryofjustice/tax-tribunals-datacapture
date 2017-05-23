'use strict';

moj.Modules.gaEvents = {
  radioFormClass: '.ga-radioButtonGroup',
  checkboxClass: '.ga-checkbox',
  linkClass: '.ga-pageLink',
  submitFormClass: '.ga-submitForm',
  fileUploadFormClass: '.ga-fileUpload',

  init: function() {
    var self = this;

    // don't bind anything if the GA object isn't defined
    if(typeof window.ga !== 'undefined') {
      if($(self.radioFormClass).length) {
        self.trackRadioForms();
      }
      if($(self.checkboxClass).length) {
        self.trackCheckboxes();
      }
      if($(self.linkClass).length) {
        self.trackLinks();
      }
      if($(self.submitFormClass).length) {
        self.trackSubmitForms();
      }
      if($(self.fileUploadFormClass).length) {
        self.trackFileUploads();
      }
    }
  },

  trackRadioForms: function() {
    var self = this,
        $form = $(self.radioFormClass);

    // submitting GA tracked radio groups is intercepted[1] until the GA event
    // has been sent, by sending target to make a callback[2]
    $form.on('submit', function(e) {
      var eventData,
          options;

      e.preventDefault(); // [1]

      eventData = self.getRadioChoiceData($form);
      options = {
        actionType: 'form',
        actionValue: $form // [2]
      };

      self.sendAnalyticsEvent(eventData, options);
    });
  },

  trackCheckboxes: function() {
    var self = this,
        $checkboxes = $(self.checkboxClass);

    // submitting forms containing a GA tracked checkbox is intercepted[1]
    // until the GA event has been send, by sending target to make a
    // callback[2], unless no GA checkboxes in the form are checked, in which
    // case unbind and submit the form directly[3]
    $checkboxes.each(function(n, checkbox) {
      var $form = $(checkbox).closest('form');

      $form.on('submit', function(e) {
        var eventDataArray,
            options = {};

        e.preventDefault(); // [1]

        if($form.find(self.checkboxClass + ':checked').length) {
          eventDataArray = self.getCheckboxFormData($form);

          // there could be multiple GA checkboxes that are checked and need a
          // GA event firing, but we only want to submit the form after sending
          // the last one
          eventDataArray.forEach(function(eventData, n) {
            if(n === eventDataArray.length - 1) {
              options = {
                actionType: 'form',
                actionValue: $form // [2]
              };
            }

            self.sendAnalyticsEvent(eventData, options);
          });
        } else {
          $form.unbind('submit').trigger('submit'); // [3]
        }
      });
    });
  },

  trackLinks: function() {
    var self = this,
        $links = $(self.linkClass);

    // following GA tracked links is intercepted[1] until the GA event has
    // been sent, by sending target to make a callback[2]
    $links.on('click', function(e) {
      var $link = $(e.target),
          eventData,
          options;

      e.preventDefault(); // [1]

      eventData = self.getLinkData($link);
      options = {
        actionType: 'link',
        actionValue: $link // [2]
      };

      self.sendAnalyticsEvent(eventData, options);
    });
  },

  trackSubmitForms: function() {
    var self = this,
        $form = $(self.submitFormClass);

    // submitting GA tracked forms is intercepted[1] until the GA event has
    // been sent, by sending target to make a callback[2]
    $form.on('submit', function(e) {
      var eventData,
          options;

      e.preventDefault(); // [1]

      eventData = self.getFormData($form);
      options = {
        actionType: 'form',
        actionValue: $form // [2]
      };

      self.sendAnalyticsEvent(eventData, options);
    });
  },

  trackFileUploads: function() {
    var self = this,
        $fileEls = $(self.fileUploadFormClass).find('[type="file"]');

    $fileEls.on('click', function(e) {
      var eventData = self.getFileUploadData($(e.target));

      self.sendAnalyticsEvent(eventData);
    });
  },

  getLinkData: function($link) {
    var eventData;

    eventData = {
      eventCategory: $link.data('ga-category'),
      eventAction: 'select_link',
      eventLabel: $link.data('ga-label')
    };

    return eventData;
  },

  getRadioChoiceData: function($form) {
    var $selectedRadio = $form.find('input[type="radio"]:checked'),
        stepName = $selectedRadio.attr('name'),
        selectedValue = $selectedRadio.val(),
        eventData;

    eventData = {
      eventCategory: stepName,
      eventAction: 'choose',
      eventLabel: selectedValue
    };

    return eventData;
  },

  getCheckboxFormData: function($form) {
    var self = this,
        checkedCheckboxes = $form.find(self.checkboxClass + ':checked'),
        eventDataArray = [];

    checkedCheckboxes.each(function(n, checkbox) {
      var $checkbox = $(checkbox),
          eventData;

      eventData = {
        hitType: 'event',
        eventCategory: $checkbox.attr('name'),
        eventAction: 'checkbox',
        eventLabel: $checkbox.data('ga-label')
      };

      eventDataArray.push(eventData);
    });

    return eventDataArray;
  },

  getFormData: function($form) {
    var category = $form.data('ga-category'),
        label = $form.data('ga-label'),
        eventData;

    eventData = {
      eventCategory: category,
      eventAction: 'submit_form',
      eventLabel: label
    };

    return eventData;
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

    return eventData;
  },

  sendAnalyticsEvent: function(eventData, opts) {
    var self = this,
        opts = opts || {};

    ga('send', 'event', eventData.eventCategory, eventData.eventAction, eventData.eventLabel, {
      hitCallback: self.createFunctionWithTimeout(function() {
        if(opts.actionType) {
          if(opts.actionType === 'form') {
            opts.actionValue.unbind('submit').trigger('submit');
          } else if(opts.actionType === 'link') {
            if(opts.actionValue.attr('target')) {
              window.open(opts.actionValue.attr('href'), opts.actionValue.attr('target'));
            } else {
              document.location = opts.actionValue.attr('href');
            }
          }
        }
      })
    });
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
