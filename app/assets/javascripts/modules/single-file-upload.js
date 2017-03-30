'use strict';

moj.Modules.singleFileUpload = {
  input_class: '.single-file-upload',
  spinnerImagePath: '/assets/spinner.gif',

  init: function() {
    var self = this;

    if($(self.input_class).length) {
      self.bindEvents();
      self.preloadSpinner();
    }
  },

  bindEvents: function() {
    var self = this,
        $el = $(self.input_class).eq(0),
        $form = $el.closest('form');

    $el.on('change', function() {
      var statusText = '';

      if($el.val()) {
        statusText = moj.Modules.fileUploadSelectedText;
      }
      $('.js-file-status').text(statusText);
    });

    $form.on('submit', function() {
      if($el.val()) {
        $('.js-file-status').html('<img class="upload-spinner" src="' + self.spinnerImagePath + '" alt=""> ' + moj.Modules.fileUploadUploadingText);
      }
    });
  },

  preloadSpinner: function() {
    var self = this;

    new Image().src = self.spinnerImagePath;
  }
};
