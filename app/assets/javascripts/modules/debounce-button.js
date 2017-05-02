'use strict';

moj.Modules.debounceButton = {
  button_class: '.js-debounce',

  init: function() {
    var self = this;

    if($(self.button_class).length) {
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this,
        disableClass = 'disabled';

    $(self.button_class).on('click', function(e) {
      var $button = $(e.target);

      if($button.hasClass(disableClass)) {
        e.preventDefault();
      } else {
        $button.addClass(disableClass);

        if($button.hasClass('js-busy')) {
          $button.val($button.data('busy-text')).after('<img class="busy-spinner" src="' + moj.Modules.singleFileUpload.spinnerImagePath + '" alt=""> ');
        }
      }
    });
  }
};
