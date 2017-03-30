'use strict';

moj.Modules.singleFileUpload = {
  input_class: '.single-file-upload',
  spinnerImagePath: moj.Modules.fileUploadSpinnerPath,
  strings: {
    selected: moj.Modules.fileUploadSelectedText,
    uploading: moj.Modules.fileUploadUploadingText
  },

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
        statusText = self.strings.selected;
      }
      $('.js-file-status').text(statusText);
    });

    $form.on('submit', function() {
      if($el.val()) {
        $('.js-file-status').html('<img class="upload-spinner" src="' + self.spinnerImagePath + '" alt=""> ' + self.strings.uploading);
      }
    });
  },

  preloadSpinner: function() {
    var self = this;

    new Image().src = self.spinnerImagePath;
  }
};
