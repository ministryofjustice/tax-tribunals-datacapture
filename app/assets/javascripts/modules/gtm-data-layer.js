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

    $form.on('submit', function(e) {
      var eventData;

      eventData = self.getRadioChoiceData($form);

      self.push(eventData);
    });
  },

  getRadioChoiceData: function($form) {
    var self = this,
        $selectedRadio = $form.find('input[type="radio"]:checked'),
        selectedValue = $selectedRadio.val(),
        eventData = {};

    eventData['event'] = self.event;
    eventData[self.var_name] = selectedValue;

    return eventData;
  },

  push: function(eventData) {
    window.dataLayer.push(eventData);
  }
};
