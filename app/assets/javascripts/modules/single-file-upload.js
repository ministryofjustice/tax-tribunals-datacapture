'use strict';

moj.Modules.singleFileUpload = {
  input_class: '.single-file-upload',
  remove_class: '.remove-btn',
  spinnerImagePath: moj.Modules.fileUploadSpinnerPath,
  strings: {
    selected: moj.t('moj.Modules.fileUploadSelectedText'),
    uploading: moj.t('moj.Modules.fileUploadUploadingText')
  },

  init: function() {
    var self = this;

    self.preloadSpinner();
    if($(self.input_class).length) {
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this,
        $el = $(self.input_class).eq(0),
        $removeBtn = $(self.remove_class),
        $form = $el.closest('form');

    $removeBtn.hide();
    $el.on('change', function() {
      var statusText = '';

      if($el.val()) {
          statusText = self.strings.selected;
          $removeBtn.show();
      }else {
          $removeBtn.hide();
      }
      $('.js-file-status').text(statusText);
    });



    $removeBtn.on('click', function (e){
        $el.val(null);
        $removeBtn.hide();
        $('.js-file-status').text('');
    });

    $form.on('submit', function() {
      if($el.val()) {
        $('.js-file-status').html('<img class="busy-spinner" src="' + self.spinnerImagePath + '" alt=""> ' + self.strings.uploading);
      }
    });
  },

  preloadSpinner: function() {
    var self = this;

    new Image().src = self.spinnerImagePath;
  }
};
