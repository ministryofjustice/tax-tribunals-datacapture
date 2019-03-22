'use strict';

moj.gtmDataLayerEvent = {
  radioFormClass: '.gtm-radioButtonGroup',
  event: '',
  var_name: '',

  init: function(event, var_name) {
    var self = this;

    self.event = event;
    self.var_name = var_name;

    // don't bind anything if the dataLayer object isn't defined
    if(typeof window.dataLayer !== 'undefined') {
      if($(self.radioFormClass).length) {
        self.trackRadioForms();
      }
    }
  },

  trackRadioForms: function() {
    var self = this,
        $form = $(self.radioFormClass);

    // submitting the form is intercepted[1] until the GTM event
    // has been pushed to the datalayer, by sending target to make a call[2]
    $form.on('submit', function(e) {
      var eventData,
          options;

      e.preventDefault(); // [1]

      eventData = self.getRadioChoiceData($form);
      options = {
        actionType: 'form',
        actionValue: $form // [2]
      };

      self.push(eventData, options);
    });
  },

  getRadioChoiceData: function($form) {
    var self = this,
        $selectedRadio = $form.find('input[type="radio"]:checked'),
        selectedValue = $selectedRadio.val(),
        eventData,


    eventData = {
      event: self.event,
    };
    eventData[self.var_name] = selectedValue;

    return eventData;
  },

  push: function(eventData, opts) {
    var self = this,
        opts = opts || {};

    window.dataLayer.push(eventData);

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
    }
  },
};
